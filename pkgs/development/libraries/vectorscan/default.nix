{ lib
, stdenv
, fetchFromGitHub
, cmake
, ragel
, util-linux
, python3
, boost
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "vectorscan";
  version = "5.4.9";

  src = fetchFromGitHub {
    owner = "VectorCamp";
    repo = "vectorscan";
    rev = "vectorscan/${version}";
    hash = "sha256-V5Qgr8aH1H+ZoJ0IZ52HIDRZq+yIwHjLf3gU/ZhjjlY=";
  };

  nativeBuildInputs = [
    cmake
    ragel
    python3
  ] ++ lib.optional stdenv.isLinux util-linux;

  buildInputs = [
    boost
  ];

  cmakeFlags = lib.optional enableShared "-DBUILD_STATIC_AND_SHARED=ON"
    ++ [ "-DFAT_RUNTIME=${if stdenv.hostPlatform.isLinux then "ON" else "OFF"}" ]
    ++ lib.optional stdenv.hostPlatform.avx2Support "-DBUILD_AVX2=ON"
    ++ lib.optional stdenv.hostPlatform.avx512Support "-DBUILD_AVX512=ON"
  ;

  meta = with lib; {
    description = "A portable fork of the high-performance regular expression matching library";
    longDescription = ''
      A fork of Intel's Hyperscan, modified to run on more platforms. Currently
      ARM NEON/ASIMD is 100% functional, and Power VSX are in development.
      ARM SVE2 will be implemented when hardware becomes accessible to the
      developers. More platforms will follow in the future, on demand/request.

      Vectorscan will follow Intel's API and internal algorithms where possible,
      but will not hesitate to make code changes where it is thought of giving
      better performance or better portability. In addition, the code will be
      gradually simplified and made more uniform and all architecture specific
      code will be abstracted away.
    '';
    homepage = "https://www.vectorcamp.gr/vectorscan/";
    changelog = "https://github.com/VectorCamp/vectorscan/blob/${src.rev}/CHANGELOG.md";
    platforms = platforms.unix;
    license = with licenses; [ bsd3 /* and */ bsd2 /* and */ licenses.boost ];
    maintainers = with maintainers; [ tnias vlaci ];
  };
}
