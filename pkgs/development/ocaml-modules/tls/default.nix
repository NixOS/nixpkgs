{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, topkg
, ppx_sexp_conv, result, x509, nocrypto, cstruct-sexp, ppx_cstruct, cstruct-unix, ounit
, lwt     ? null}:

with stdenv.lib;

let withLwt = lwt != null; in

if !versionAtLeast ocaml.version "4.04"
then throw "tls is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.10.4";
  name = "ocaml${ocaml.version}-tls-${version}";

  src = fetchFromGitHub {
    owner  = "mirleft";
    repo   = "ocaml-tls";
    rev    = version;
    sha256 = "02wv4lia583imn3sfci4nqv6ac5nzig5j3yfdnlqa0q8bp9rfc6g";
  };

  buildInputs = [ ocaml ocamlbuild findlib topkg ppx_sexp_conv ppx_cstruct ]
  ++ optionals doCheck [ ounit cstruct-unix ];
  propagatedBuildInputs = [ cstruct-sexp nocrypto result x509 ] ++
                          optional withLwt lwt;

  buildPhase = "${topkg.run} build --tests ${boolToString doCheck} --with-mirage false --with-lwt ${boolToString withLwt}";

  doCheck = versionAtLeast ocaml.version "4.06";
  checkPhase = "${topkg.run} test";

  inherit (topkg) installPhase;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirleft/ocaml-tls;
    description = "TLS in pure OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
