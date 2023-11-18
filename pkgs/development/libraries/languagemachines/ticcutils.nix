{ lib, stdenv, fetchurl
, automake, autoconf, libtool, pkg-config, autoconf-archive
, libxml2, zlib, bzip2, libtar }:

let
  release = lib.importJSON ./release-info/LanguageMachines-ticcutils.json;
in

stdenv.mkDerivation {
  pname = "ticcutils";
  version = release.version;
  src = fetchurl { inherit (release) url sha256;
                   name = "ticcutils-${release.version}.tar.gz"; };
  nativeBuildInputs = [ pkg-config automake autoconf ];
  buildInputs = [ libtool autoconf-archive libxml2
                  # optional:
                  zlib bzip2 libtar
                  # broken but optional: boost
                ];
  preConfigure = "sh bootstrap.sh";

  meta = with lib; {
    description = "This module contains useful functions for general use in the TiCC software stack and beyond.";
    homepage    = "https://github.com/LanguageMachines/ticcutils";
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ roberth ];
  };

}
