{ stdenv, buildOcaml, fetchFromGitHub, findlib, ocamlbuild, ocaml_oasis
, ppx_tools, ppx_sexp_conv, result, x509, nocrypto, cstruct, ppx_cstruct, cstruct-unix, ounit
, lwt     ? null}:

with stdenv.lib;

let withLwt = lwt != null; in

buildOcaml rec {
  version = "0.7.1";
  name = "tls";

  minimunSupportedOcamlVersion = "4.02";

  src = fetchFromGitHub {
    owner  = "mirleft";
    repo   = "ocaml-tls";
    rev    = "${version}";
    sha256 = "19q2hzxiasz9pzczgb63kikg0mc9mw98dfvch5falf2rincycj24";
  };

  buildInputs = [ ocamlbuild findlib ocaml_oasis ppx_sexp_conv ounit ppx_cstruct cstruct-unix ];
  propagatedBuildInputs = [ cstruct nocrypto result x509 ] ++
                          optional withLwt lwt;

  configureFlags = [ "--disable-mirage" "--enable-tests" ] ++
                   optional withLwt ["--enable-lwt"];

  configurePhase = "./configure --prefix $out $configureFlags";

  doCheck = true;
  checkTarget = "test";
  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirleft/ocaml-tls;
    description = "TLS in pure OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
