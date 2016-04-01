{ stdenv, fetchurl, ocaml, findlib, ocurl, cryptokit, ocaml_extlib, yojson, ocamlnet, xmlm }:

stdenv.mkDerivation rec {
  name = "gapi-ocaml-0.2.10";
  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1601/${name}.tar.gz";
    sha256 = "0kg4j7dhr7jynpy8x53bflqjf78jyl14j414l6px34xz7c9qx5fl";
  };
  buildInputs = [ ocaml findlib ];
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
