{ lib, stdenv, fetchurl, unzip }:

let

  src = fetchurl {
    url = "http://www.oasis-open.org/docbook/sgml/4.5/docbook-4.5.zip";
    hash = "sha256-gEPlFOgMbBnLFGtdN5N9EwW/Or+bAJfDbff3D2Ec30M=";
  };

  isoents = fetchurl {
    url = "http://www.oasis-open.org/cover/ISOEnts.zip";
    sha256 = "1clrkaqnvc1ja4lj8blr0rdlphngkcda3snm7b9jzvcn76d3br6w";
  };

in

stdenv.mkDerivation {
  pname = "docbook-sgml";
  version = "4.5";

  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase =
    ''
      o=$out/sgml/dtd/docbook-4.5
      mkdir -p $o
      cd $o
      unzip ${src}
      unzip ${isoents}
      sed -e "s/iso-/ISO/" -e "s/.gml//" -i docbook.cat
    '';

  meta = {
    platforms = lib.platforms.unix;
  };
}
