{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, opam, topkg, cppo
, ppx_import, ppx_deriving, yojson, ounit
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ppx_deriving_yojson-${version}";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "ppx_deriving_yojson";
    rev = "v${version}";
    sha256 = "1id1a29qq0ax9qp98b5hv6p2q2r0vp4fbkkwzm1bxdhnasw97msk";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam cppo ounit ppx_import ];

  propagatedBuildInputs = [ ppx_deriving yojson ];

  inherit (topkg) installPhase;

  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "A Yojson codec generator for OCaml >= 4.02.";
    inherit (src.meta) homepage;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
