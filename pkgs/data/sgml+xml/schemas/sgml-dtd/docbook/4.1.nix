{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

let

  src = fetchurl {
    url = "http://www.oasis-open.org/docbook/sgml/4.1/docbk41.zip";
    sha256 = "04b3gp4zkh9c5g9kvnywdkdfkcqx3kjc04j4mpkr4xk7lgqgrany";
  };

  isoents = fetchurl {
    url = "http://www.oasis-open.org/cover/ISOEnts.zip";
    sha256 = "1clrkaqnvc1ja4lj8blr0rdlphngkcda3snm7b9jzvcn76d3br6w";
  };

in

stdenv.mkDerivation {
  name = "docbook-sgml-4.1";

  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    o=$out/sgml/dtd/docbook-4.1
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
