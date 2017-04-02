{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, ocurl, cryptokit, ocaml_extlib, yojson, ocamlnet, xmlm }:

stdenv.mkDerivation rec {
  name = "gapi-ocaml-0.3.1";
  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1665/${name}.tar.gz";
    sha256 = "1fn563k9mpqp61909l5bzddnkyn04bk106vrcr7qiim1d2i6cf8i";
  };
  buildInputs = [ ocaml findlib ocamlbuild ];
  propagatedBuildInputs = [ ocurl cryptokit ocaml_extlib yojson ocamlnet xmlm ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";
  createFindlibDestdir = true;

  meta = {
    description = "OCaml client for google services";
    homepage = http://gapi-ocaml.forge.ocamlcore.org;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ bennofs ];
    platforms = ocaml.meta.platforms or [];
  };
}
