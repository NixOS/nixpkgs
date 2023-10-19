{ lib, stdenv, llvm_meta
, buildLlvmTools
, fetch
, cmake
, libllvm
, version
}:

stdenv.mkDerivation rec {
  pname = "lld";
  inherit version;

  src = fetch "lld" "1ah75rjly6747jk1zbwca3z0svr9b09ylgxd4x9ns721xir6sia6";

  patches = [
    ./gnu-install-dirs.patch
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libllvm ];

  cmakeFlags = [
    "-DLLVM_CONFIG_PATH=${libllvm.dev}/bin/llvm-config${lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) "-native"}"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DLLVM_TABLEGEN_EXE=${buildLlvmTools.llvm}/bin/llvm-tblgen"
  ];

  # Musl's default stack size is too small for lld to be able to link Firefox.
  LDFLAGS = lib.optionalString stdenv.hostPlatform.isMusl "-Wl,-z,stack-size=2097152";

  outputs = [ "out" "lib" "dev" ];

  meta = llvm_meta // {
    broken = stdenv.isDarwin;
    homepage = "https://lld.llvm.org/";
    description = "The LLVM linker (unwrapped)";
    longDescription = ''
      LLD is a linker from the LLVM project that is a drop-in replacement for
      system linkers and runs much faster than them. It also provides features
      that are useful for toolchain developers.
      The linker supports ELF (Unix), PE/COFF (Windows), and Mach-O (macOS)
      in descending order of completeness. Internally, LLD consists
      of several different linkers.
    '';
  };
}
