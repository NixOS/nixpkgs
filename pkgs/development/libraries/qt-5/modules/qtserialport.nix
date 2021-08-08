{ qtModule, stdenv, lib, qtbase, systemd }:

let inherit (lib) getLib optional; in

qtModule {
  pname = "qtserialport";
  qtInputs = [ qtbase ];
  NIX_CFLAGS_COMPILE =
    optional stdenv.isLinux
    ''-DNIXPKGS_LIBUDEV="${getLib systemd}/lib/libudev"'';
}
