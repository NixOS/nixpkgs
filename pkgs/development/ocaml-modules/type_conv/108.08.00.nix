{stdenv, fetchurl, ocaml, findlib, camlp4}:

if !stdenv.lib.versionAtLeast ocaml.version "3.12"
|| stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "type_conv-108.08.00 is not available for OCaml ${ocaml.version}" else

stdenv.mkDerivation {
  name = "ocaml-type_conv-108.08.00";

  src = fetchurl {
    url = https://ocaml.janestreet.com/ocaml-core/108.08.00/individual/type_conv-108.08.00.tar.gz;
    sha256 = "08ysikwwp69zvc147lzzg79nwlrzrk738rj0ggcfadi8h5il42sl";
  };

  buildInputs = [ocaml findlib camlp4];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://ocaml.janestreet.com/;
    description = "Support library for OCaml preprocessor type conversions";
    license = licenses.asl20;
    branch = "108";
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ z77z ];
  };
}
