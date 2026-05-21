{
  lib,
  backendStdenv,
  buildRedist,
  cudaOlder,
  glibc,
}:
buildRedist {
  redistName = "cuda";
  pname = "cuda_crt";

  outputs = [ "out" ];

  # Fix compatibility with glibc 2.42:
  # - CUDA >= 13.0 fixed sinpi/cospi (using __NV_IEC_60559_FUNCS_EXCEPTION_SPECIFIER), but
  #   rsqrt/rsqrtf in math_functions.h still lack noexcept, conflicting with glibc 2.42's
  #   declarations.
  # - CUDA >= 13.2 fixed rsqrt/rsqrtf as well (using _NV_RSQRT_SPECIFIER).
  postInstall = lib.optionalString (cudaOlder "13.2" && lib.versionAtLeast glibc.version "2.42") ''
    nixLog "Patching math_functions.h rsqrt signatures to match glibc's ones"
    substituteInPlace "''${!outputInclude:?}/include/crt/math_functions.h" \
      --replace-fail \
        "rsqrt(double x);" \
        "rsqrt(double x) noexcept (true);" \
      --replace-fail \
        "rsqrtf(float x);" \
        "rsqrtf(float x) noexcept (true);"

    nixLog "Patching math_functions.hpp rsqrt signatures to match glibc's ones"
    substituteInPlace "''${!outputInclude:?}/include/crt/math_functions.hpp" \
      --replace-fail \
        "__func__(double rsqrt(const double a))" \
        "__func__(double rsqrt(const double a) throw())" \
      --replace-fail \
        "__func__(float rsqrtf(const float a))" \
        "__func__(float rsqrtf(const float a) throw())"
  '';

  brokenAssertions = [
    # TODO(@connorbaker): Build fails on x86 when using pkgsLLVM.
    #  .../include/crt/host_defines.h:67:2:
    #  error: "libc++ is not supported on x86 system"
    #
    #     67 | #error "libc++ is not supported on x86 system"
    #        |  ^
    #
    #  1 error generated.
    #
    #  # --error 0x1 --
    {
      message = "cannot use libc++ on x86_64-linux";
      assertion = backendStdenv.hostNixSystem == "x86_64-linux" -> backendStdenv.cc.libcxx == null;
    }
  ];

  # There's a comment with a reference to /usr
  allowFHSReferences = true;
}
