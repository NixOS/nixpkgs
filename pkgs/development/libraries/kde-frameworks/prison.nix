{
  mkDerivation,
  extra-cmake-modules,
  libdmtx,
  qrencode,
  qtbase,
  qtmultimedia,
  zxing-cpp,
}:

mkDerivation {
  pname = "prison";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    libdmtx
    qrencode
    zxing-cpp
  ];
  propagatedBuildInputs = [
    qtbase
    qtmultimedia
  ];
  outputs = [
    "out"
    "dev"
  ];
}
