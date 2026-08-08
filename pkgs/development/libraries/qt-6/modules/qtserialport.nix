{
  qtModule,
  stdenv,
  lib,
  qtbase,
  udev,
}:

qtModule {
  pname = "qtserialport";
  propagatedBuildInputs = [ qtbase ] ++ lib.optionals stdenv.hostPlatform.isLinux [ udev ];
}
