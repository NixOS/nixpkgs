{
  lib,
  buildRedist,
  cudaOlder,
  glibc,
  manifests,
}:
buildRedist {
  redistName = "cuda";
  pname = "cuda_crt";

  # CUDA 12 bundles CRT headers with NVCC. Extract them into the same SDK
  # component used by CUDA 13 so consumers never need a compiler for headers.
  release = manifests.cuda.${if cudaOlder "13.0" then "cuda_nvcc" else "cuda_crt"} or null;
  outputs = [ "out" ];
  preInstall = lib.optionalString (cudaOlder "13.0") ''
    rm -rf bin lib lib64 nvvm nvvm-next
  '';

  # glibc 2.42 added exception specifications. CUDA 13 fixed sinpi/cospi;
  # CUDA 13.2 fixed rsqrt. Patch whichever declarations still need it.
  postInstall =
    lib.optionalString (cudaOlder "13.2" && lib.versionAtLeast glibc.version "2.42") ''
      for functionName in rsqrt rsqrtf ${lib.optionalString (cudaOlder "13.0") "sinpi sinpif cospi cospif"}; do
        type=double
        [[ $functionName != *f ]] || type=float
        argument="$type a"
        [[ $functionName != rsqrt* && $type != float ]] || argument="const $argument"
        substituteInPlace "''${!outputInclude:?}/include/crt/math_functions.h" \
          --replace-fail "$functionName($type x);" "$functionName($type x) noexcept (true);"
        substituteInPlace "''${!outputInclude:?}/include/crt/math_functions.hpp" \
          --replace-fail "__func__($type $functionName($argument))" "__func__($type $functionName($argument) throw())"
      done
    ''

    # Fix clang CUDA compilation: host_defines.h redefines __noinline__ as
    # __attribute__((noinline)), which conflicts with libstdc++ >=12 using
    # __attribute__((__noinline__)) — the macro expands to
    # __attribute__((__attribute__((noinline)))) which is invalid.
    # Clang natively understands __noinline__ as an attribute so the macro
    # is unnecessary. Skip it when clang is the compiler.
    + lib.optionalString (cudaOlder "13.0") ''
      nixLog "Patching host_defines.h to skip __noinline__ macro under clang"
      substituteInPlace "''${!outputInclude:?}/include/crt/host_defines.h" \
        --replace-fail \
          '#if defined(__CUDACC__) || defined(__CUDA_ARCH__) || defined(__CUDA_LIBDEVICE__)' \
          '#if (defined(__CUDACC__) || defined(__CUDA_ARCH__) || defined(__CUDA_LIBDEVICE__)) && !defined(__clang__)'
    ''

    # NVIDIA's frontend lacks this builtin used by glibc's Clang fortify
    # implementation. Use the checked libc entry point, preserving fortify.
    # features.h must have selected the libc and fortify level first.
    + ''
      substituteInPlace "''${!outputInclude:?}/include/crt/host_config.h" \
        --replace-fail '#include <features.h> /* for __THROW */' '#include <features.h> /* for __THROW */
      #if defined(__NVCC__) && defined(__clang__) && defined(__GLIBC__) && __USE_FORTIFY_LEVEL > 1
      #ifndef __builtin___vfprintf_chk
      #define __builtin___vfprintf_chk __vfprintf_chk
      #endif
      #endif'
    ''

    # CUDA 12 rejects glibc's extern Clang fortify overloads. Keep their
    # object-size attributes and checked bodies, using internal linkage as
    # glibc already does for variadic wrappers. In Clang >=10, C++ GNU inline
    # definitions without extern remain externally available, so ordinary
    # non-overloaded fortify wrappers still emit no libc definitions.
    + lib.optionalString (cudaOlder "13.0") ''
      substituteInPlace "''${!outputInclude:?}/include/crt/host_config.h" \
        --replace-fail '#include <features.h> /* for __THROW */' '#include <features.h> /* for __THROW */
      #if defined(__NVCC__) && defined(__clang__) && __clang_major__ >= 10 && defined(__GLIBC__) && __fortify_use_clang && __USE_FORTIFY_LEVEL > 0
      #undef __fortify_function
      #define __fortify_function __inline __attribute__((__always_inline__)) __attribute__((__gnu_inline__)) __attribute_artificial__
      #undef __attribute_overloadable__
      #define __attribute_overloadable__ static __attribute__((__overloadable__))
      #undef __fortify_function_error_function
      #define __fortify_function_error_function __attribute__((__unused__))
      #endif'
    '';

  # There's a comment with a reference to /usr
  allowFHSReferences = true;
}
