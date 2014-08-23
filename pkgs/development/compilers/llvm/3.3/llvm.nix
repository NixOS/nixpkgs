{ stdenv, fetchurl, perl, groff, cmake, python, libffi, binutils }:
let
  version = "3.3";
in stdenv.mkDerivation rec {
  name = "llvm-${version}";

  src = fetchurl {
    url = "http://llvm.org/releases/${version}/llvm-${version}.src.tar.gz";
    sha256 = "0y3mfbb5qzcpw3v5qncn69x1hdrrrfirgs82ypi2annhf0g6nxk8";
  };

  patches = [
    ./more-memory-for-bugpoint.patch # The default rlimits in 3.3 are too low for shared libraries.
    ./no-rule-aarch64.patch          # http://llvm.org/bugs/show_bug.cgi?id=16625
  ];

  buildInputs = [ perl groff cmake python libffi ];

  # hacky fix: created binaries need to be run before installation
  preBuild = let LD = if stdenv.isDarwin then "DYLD" else "LD";
    in "export ${LD}_LIBRARY_PATH='$$${LD}_LIBRARY_PATH:'`pwd`/lib";

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_BUILD_TESTS=ON"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_BINUTILS_INCDIR=${binutils}/include"
    "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=R600" # for mesa
  ] ++ stdenv.lib.optional (!isDarwin) "-DBUILD_SHARED_LIBS=ON";

  postBuild = ''
    paxmark m bin/{lli,llvm-rtdyld}

    paxmark m unittests/ExecutionEngine/JIT/JITTests
    paxmark m unittests/ExecutionEngine/MCJIT/MCJITTests
    paxmark m unittests/Support/SupportTests
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 raskin viric ];
    platforms   = platforms.all;
  };
}
