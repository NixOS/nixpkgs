{
  mkDerivation,
  cmake,
  extra-cmake-modules,
  libpthread-stubs,
  libxdmcp,
  qtbase,
  qttools,
  qtx11extras,
}:

mkDerivation {
  pname = "kwindowsystem";
  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    libpthread-stubs
    libxdmcp
    qttools
    qtx11extras
  ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
  ];
}
