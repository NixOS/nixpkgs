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
  propagatedBuildInputs = [ qtbase ];
  env.NIX_CFLAGS_COMPILE = lib.optionalString udevSupport "-DNIXPKGS_LIBUDEV=\"${udev}/lib/libudev\"";
}
