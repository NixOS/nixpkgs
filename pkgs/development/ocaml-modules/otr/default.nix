{ stdenv, fetchFromGitHub, ocaml, ocamlbuild, findlib, topkg
, ppx_tools, ppx_sexp_conv, cstruct, ppx_cstruct, sexplib, rresult, nocrypto
, astring
}:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "otr is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-otr-${version}";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "ocaml-otr";
    rev    = "${version}";
    sha256 = "0ixf0jvccmcbhk5mhzqakfzimvz200wkdkq3z2d0bdzyggslbdl4";
  };

  buildInputs = [ ocaml ocamlbuild findlib topkg ppx_tools ppx_sexp_conv ppx_cstruct ];
  propagatedBuildInputs = [ cstruct sexplib rresult nocrypto astring ];

  buildPhase = "${topkg.run} build --tests true";

  inherit (topkg) installPhase;

  doCheck = true;
  checkPhase = "${topkg.run} test";

  meta = with stdenv.lib; {
    inherit (ocaml.meta) platforms;
    homepage = https://github.com/hannesm/ocaml-otr;
    description = "Off-the-record messaging protocol, purely in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
