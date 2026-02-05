{
  mkDerivation,
  extra-cmake-modules,
  libpthread-stubs,
  libXdmcp,
  qtbase,
  qttools,
  qtx11extras,
}:

mkDerivation {
  pname = "kwindowsystem";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    libpthread-stubs
    libXdmcp
    qttools
    qtx11extras
  ];
  propagatedBuildInputs = [ qtbase ];
  outputs = [
    "out"
    "dev"
  ];
}
