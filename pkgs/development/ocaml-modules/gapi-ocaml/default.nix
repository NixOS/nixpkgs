{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, ocurl, cryptokit, ocaml_extlib, yojson, ocamlnet, xmlm }:

stdenv.mkDerivation rec {
  name = "gapi-ocaml-${version}";
  version = "0.3.4";
  src = fetchFromGitHub {
    owner = "astrada";
    repo = "gapi-ocaml";
    rev = "v${version}";
    sha256 = "07p6p108fyf9xz54jbcld40k3r9zyybxmr5i3rrkhgwm8gb6sbhv";
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
