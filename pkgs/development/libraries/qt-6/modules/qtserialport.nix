{
  qtModule,
  stdenv,
  lib,
  qtbase,
  udev,
  udevSupport ? stdenv.hostPlatform.isLinux,
  pkg-config,
}:

qtModule {
  pname = "qtserialport";
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ qtbase ] ++ lib.optionals udevSupport [ udev ];
}
