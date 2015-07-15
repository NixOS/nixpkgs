{stdenv, fetchurl, ocaml, cmdliner, cstruct, findlib, io-page, ipaddr, lwt, mirage-types, ounit}:

stdenv.mkDerivation {
  name = "ocaml-mirage-1.2.0";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage/archive/v1.2.0/mirage-1.2.0.tar.gz";
    sha256 = "1mfi74bxwgmdnjb4ka4xd4y5d1z29p6f9q8hs2j15vk70cyb0jxl";
  };

  buildInputs = [ ocaml cmdliner cstruct findlib io-page ipaddr lwt mirage-types ounit ];

  configurePhase = "true";

  buildPhase = ''
    make PREFIX=$out
    '';

  createFindlibDestdir = true;

  installPhase = ''
    mkdir -p $out/bin
    make install
    '';

  meta = {
    homepage = https://github.com/mirage/mirage;
    description = "MirageOS interfaces";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
