{ stdenv, fetchurl
, automake, autoconf, libtool, pkgconfig, autoconf-archive
, libxml2, zlib, bzip2, libtar }:

let
  release = builtins.fromJSON (builtins.readFile ./release-info/LanguageMachines-ticcutils.json);
in

stdenv.mkDerivation {
  name = "ticcutils";
  version = release.version;
  src = fetchurl { inherit (release) url sha256;
                   name = "ticcutils-${release.version}.tar.gz"; };
  buildInputs = [ automake autoconf libtool pkgconfig autoconf-archive libxml2
                  # optional:
                  zlib bzip2 libtar
                  # broken but optional: boost
                ];
  preConfigure = "sh bootstrap.sh";

  meta = with stdenv.lib; {
    description = "This module contains useful functions for general use in the TiCC software stack and beyond.";
    homepage    = https://github.com/LanguageMachines/ticcutils;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ roberth ];
  };

}
