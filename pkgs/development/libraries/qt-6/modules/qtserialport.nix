{
  qtModule,
  stdenv,
  lib,
  qtbase,
  udev,
  pkg-config,
}:

qtModule {
  pname = "qtserialport";
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ qtbase ] ++ lib.optionals stdenv.hostPlatform.isLinux [ udev ];
}
