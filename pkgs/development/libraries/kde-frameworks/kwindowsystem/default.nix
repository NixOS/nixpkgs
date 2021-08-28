{
  mkDerivation,
  extra-cmake-modules,
  libpthreadstubs, libXdmcp,
  qtbase, qttools, qtx11extras
}:

mkDerivation {
  name = "kwindowsystem";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ libpthreadstubs libXdmcp qttools qtx11extras ];
  propagatedBuildInputs = [ qtbase ];
  patches = [
    ./0001-platform-plugins-path.patch
  ];
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DNIXPKGS_QT_PLUGIN_PATH=\"''${!outputBin}/$qtPluginPrefix\""
  '';
  outputs = [ "out" "dev" ];
}
