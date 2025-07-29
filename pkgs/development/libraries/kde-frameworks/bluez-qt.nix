{
  mkDerivation,
  lib,
  extra-cmake-modules,
  qtbase,
  qtdeclarative,
  udevCheckHook,
}:

mkDerivation {
  pname = "bluez-qt";
  nativeBuildInputs = [
    extra-cmake-modules
    udevCheckHook
  ];
  buildInputs = [ qtdeclarative ];
  propagatedBuildInputs = [ qtbase ];
  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace /lib/udev/rules.d "$bin/lib/udev/rules.d"
  '';
  doInstallCheck = true;
  meta.platforms = lib.platforms.linux;
}
