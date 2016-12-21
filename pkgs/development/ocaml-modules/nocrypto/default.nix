{ stdenv, buildOcaml, fetchFromGitHub, ocaml, findlib
, cstruct, zarith, ounit, ocaml_oasis, ppx_sexp_conv, sexplib
, lwt ? null}:

with stdenv.lib;
let withLwt = lwt != null; in

buildOcaml rec {
  name = "nocrypto";
  version = "0.5.3";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchFromGitHub {
    owner  = "mirleft";
    repo   = "ocaml-nocrypto";
    rev    = "v${version}";
    sha256 = "0m3yvqpgfffqp15mcl08b78cv8zw25rnp6z1pkj5aimz6xg3gqbl";
  };

  buildInputs = [ ocaml ocaml_oasis findlib ounit ppx_sexp_conv ];
  propagatedBuildInputs = [ cstruct zarith sexplib ] ++ optional withLwt lwt;

  configureFlags = [ "--enable-tests" ] ++ optional withLwt ["--enable-lwt"];

  configurePhase = "./configure --prefix $out $configureFlags";

  doCheck = true;
  checkTarget = "test";
  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/mirleft/ocaml-nocrypto;
    description = "Simplest possible crypto to support TLS";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
