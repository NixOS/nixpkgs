{ qtModule, stdenv, lib, qtbase, systemd }:

let inherit (lib) getLib optionalString; in

qtModule {
  name = "qtserialport";
  qtInputs = [ qtbase ];
  env.NIX_CFLAGS_COMPILE =
    optionalString stdenv.isLinux
    ''-DNIXPKGS_LIBUDEV="${getLib systemd}/lib/libudev"'';
}
