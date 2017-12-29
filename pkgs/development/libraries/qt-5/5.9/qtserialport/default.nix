{ stdenv, qtSubmodule, lib, copyPathsToStore, qtbase, substituteAll, systemd }:

let inherit (lib) getLib optional; in

qtSubmodule {
  name = "qtserialport";
  qtInputs = [ qtbase ];
  patches =  copyPathsToStore (lib.readPathsFromFile ./. ./series);
  NIX_CFLAGS_COMPILE =
    optional stdenv.isLinux
    ''-DNIXPKGS_LIBUDEV="${getLib systemd}/lib/libudev"'';
}
