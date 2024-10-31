{ qtModule, stdenv, lib, qtbase, systemd }:

qtModule {
  pname = "qtserialport";
  propagatedBuildInputs = [ qtbase ];
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isLinux "-DNIXPKGS_LIBUDEV=\"${lib.getLib systemd}/lib/libudev\"";
}
