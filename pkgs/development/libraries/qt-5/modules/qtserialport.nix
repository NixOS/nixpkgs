{ qtModule, stdenv, lib, qtbase, systemd }:

qtModule {
  pname = "qtserialport";
  qtInputs = [ qtbase ];
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isLinux "-DNIXPKGS_LIBUDEV=\"${lib.getLib systemd}/lib/libudev\"";
}
