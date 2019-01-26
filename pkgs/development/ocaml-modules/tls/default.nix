{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, topkg
, ppx_sexp_conv, result, x509, nocrypto, cstruct, ppx_cstruct, cstruct-unix, ounit
, lwt     ? null}:

with stdenv.lib;

let withLwt = lwt != null; in

if !versionAtLeast ocaml.version "4.04"
then throw "tls is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.9.0";
  name = "ocaml${ocaml.version}-tls-${version}";

  src = fetchFromGitHub {
    owner  = "mirleft";
    repo   = "ocaml-tls";
    rev    = "${version}";
    sha256 = "0qgw8lq8pk9hss7b5i6fr08pi711i0zqx7yyjgcil47ipjig6c31";
  };

  buildInputs = [ ocaml ocamlbuild findlib topkg ppx_sexp_conv ounit ppx_cstruct cstruct-unix ];
  propagatedBuildInputs = [ cstruct nocrypto result x509 ] ++
                          optional withLwt lwt;

  buildPhase = "${topkg.run} build --tests true --with-mirage false --with-lwt ${if withLwt then "true" else "false"}";

  doCheck = true;
  checkPhase = "${topkg.run} test";

  inherit (topkg) installPhase;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirleft/ocaml-tls;
    description = "TLS in pure OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
