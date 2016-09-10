{stdenv, fetchurl, opam, ocaml, cstruct, cmdliner, findlib, io-page, ipaddr, lwt, ounit}:

stdenv.mkDerivation {
  name = "ocaml-mirage-types-1.2.0";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/mirage/mirage/archive/v1.2.0/mirage-1.2.0.tar.gz";
    sha256 = "1mfi74bxwgmdnjb4ka4xd4y5d1z29p6f9q8hs2j15vk70cyb0jxl";
  };

  buildInputs = [ opam ocaml cstruct cmdliner findlib io-page ipaddr lwt ounit ];

  configurePhase = "true";

  buildPhase = ''
    make build-types
    '';

  createFindlibDestdir = true;

  installPhase = ''
    make install-types
    '';

  meta = {
    homepage = https://github.com/mirage/mirage;
    description = "MirageOS interfaces";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
