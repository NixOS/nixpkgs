{ qtModule, stdenv, lib, qtbase, systemd }:

let inherit (lib) getLib optional; in

qtModule {
  name = "qtserialport";
  qtInputs = [ qtbase ];
  NIX_CFLAGS_COMPILE =
    optional stdenv.isLinux
    ''-DNIXPKGS_LIBUDEV="${getLib systemd}/lib/libudev"'';
}
