{
  stdenv,
  z3,
  cmake,
  python3,
}:

stdenv.mkDerivation {
  inherit (z3) pname version src;

  patches = [
    ./0001-fix-pkgconfig-prefixes.patch
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
  ];

  nativeBuildInputs = [
    cmake
    python3
  ];
}
