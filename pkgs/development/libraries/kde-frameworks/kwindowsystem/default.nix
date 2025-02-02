{
  mkDerivation,
  extra-cmake-modules,
  libpthreadstubs,
  libXdmcp,
  qtbase,
  qttools,
  qtx11extras,
}:

mkDerivation {
  pname = "kwindowsystem";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    libpthreadstubs
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
