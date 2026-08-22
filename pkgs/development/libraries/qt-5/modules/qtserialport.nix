{
  qtModule,
  stdenv,
  lib,
  qtbase,
  udev,
}:

qtModule {
  pname = "qtserialport";
  propagatedBuildInputs = [ qtbase ];
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isLinux "-DNIXPKGS_LIBUDEV=\"${udev}/lib/libudev\"";
}
