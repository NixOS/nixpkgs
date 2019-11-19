{ stdenv, version, fetch, cmake, python, llvm, libcxxabi }:
stdenv.mkDerivation {
  pname = "compiler-rt";
  inherit version;
  src = fetch "compiler-rt" "1n48p8gjarihkws0i2bay5w9bdwyxyxxbpwyng7ba58jb30dlyq5";

  nativeBuildInputs = [ cmake python llvm ];
  buildInputs = stdenv.lib.optional stdenv.hostPlatform.isDarwin libcxxabi;

  NIX_CFLAGS_COMPILE = [
    "-DSCUDO_DEFAULT_OPTIONS=DeleteSizeMismatch=0:DeallocationTypeMismatch=0"
  ];

  cmakeFlags = stdenv.lib.optionals (stdenv.hostPlatform.useLLVM or false || stdenv.isDarwin) [
    "-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON"
    "-DCMAKE_C_COMPILER_TARGET=${stdenv.hostPlatform.config}"
    "-DCMAKE_ASM_COMPILER_TARGET=${stdenv.hostPlatform.config}"
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform.useLLVM or false) [
    "-DCMAKE_C_FLAGS=-nodefaultlibs"
    "-DCMAKE_CXX_COMPILER_WORKS=ON"
    "-DCOMPILER_RT_BUILD_BUILTINS=ON"
    "-DCOMPILER_RT_BUILD_SANITIZERS=OFF"
    "-DCOMPILER_RT_BUILD_XRAY=OFF"
    "-DCOMPILER_RT_BUILD_LIBFUZZER=OFF"
    "-DCOMPILER_RT_BUILD_PROFILE=OFF"
    "-DCOMPILER_RT_BAREMETAL_BUILD=ON"
  ];

  outputs = [ "out" "dev" ];

  patches = [
    ./compiler-rt-codesign.patch # Revert compiler-rt commit that makes codesign mandatory
  ] ++ stdenv.lib.optional (stdenv.hostPlatform.useLLVM or false) ./crtbegin-and-end.patch
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl ./sanitizers-nongnu.patch;

  # TSAN requires XPC on Darwin, which we have no public/free source files for. We can depend on the Apple frameworks
  # to get it, but they're unfree. Since LLVM is rather central to the stdenv, we patch out TSAN support so that Hydra
  # can build this. If we didn't do it, basically the entire nixpkgs on Darwin would have an unfree dependency and we'd
  # get no binary cache for the entire platform. If you really find yourself wanting the TSAN, make this controllable by
  # a flag and turn the flag off during the stdenv build.
  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace cmake/config-ix.cmake \
      --replace 'set(COMPILER_RT_HAS_TSAN TRUE)' 'set(COMPILER_RT_HAS_TSAN FALSE)'
  '' + stdenv.lib.optionalString (stdenv.hostPlatform.useLLVM or false) ''
    substituteInPlace lib/builtins/int_util.c \
      --replace "#include <stdlib.h>" ""
    substituteInPlace lib/builtins/clear_cache.c \
      --replace "#include <assert.h>" ""
    substituteInPlace lib/builtins/cpu_model.c \
      --replace "#include <assert.h>" ""
  '';

  # Hack around weird upsream RPATH bug
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    ln -s "$out/lib"/*/* "$out/lib"
  '' + stdenv.lib.optionalString (stdenv.hostPlatform.useLLVM or false) ''
    ln -s $out/lib/*/clang_rt.crtbegin-*.o $out/lib/linux/crtbegin.o
    ln -s $out/lib/*/clang_rt.crtend-*.o $out/lib/linux/crtend.o
    ln -s $out/lib/*/clang_rt.crtbegin_shared-*.o $out/lib/linux/crtbeginS.o
    ln -s $out/lib/*/clang_rt.crtend_shared-*.o $out/lib/linux/crtendS.o
  '';

  enableParallelBuilding = true;
}
