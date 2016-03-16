{ stdenv, fetchurl, ocaml, findlib, ocurl, cryptokit, ocaml_extlib, yojson, ocamlnet, xmlm }:

stdenv.mkDerivation rec {
  name = "gapi-ocaml-0.2.6";
  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/1468/${name}.tar.gz";
    sha256 = "1sqsir07xxk9xy723l206r7d10sp6rfid9dvi0g34vbkvshm50y2";
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
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
  };
}
