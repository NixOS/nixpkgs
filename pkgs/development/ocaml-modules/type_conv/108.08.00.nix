{ lib, stdenv, fetchurl, ocaml, findlib, camlp4 }:

if !lib.versionAtLeast ocaml.version "3.12"
  || lib.versionAtLeast ocaml.version "4.03"
then throw "type_conv-108.08.00 is not available for OCaml ${ocaml.version}" else

stdenv.mkDerivation rec {
  pname = "ocaml-type_conv";
  version = "108.08.00";

  src = fetchurl {
    url = "https://ocaml.janestreet.com/ocaml-core/${version}/individual/type_conv-${version}.tar.gz";
    sha256 = "08ysikwwp69zvc147lzzg79nwlrzrk738rj0ggcfadi8h5il42sl";
  };

  nativeBuildInputs = [ ocaml findlib ];
  buildInputs = [ camlp4 ];

  strictDeps = true;

  createFindlibDestdir = true;

  meta = with lib; {
    homepage = "https://ocaml.janestreet.com/";
    description = "Support library for OCaml preprocessor type conversions";
    license = licenses.asl20;
    branch = "108";
    platforms = ocaml.meta.platforms or [ ];
    maintainers = with maintainers; [ maggesi ];
  };
}
