{
  qtModule,
  stdenv,
  lib,
  qtbase,
  udev,
  udevSupport ? stdenv.hostPlatform.isLinux,
}:

qtModule {
  pname = "qtserialport";
  propagatedBuildInputs = [ qtbase ] ++ lib.optionals udevSupport [ udev ];
}
