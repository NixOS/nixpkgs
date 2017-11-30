{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, opam, topkg, cppo
, ppx_import, ppx_deriving, yojson, ounit
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ppx_deriving_yojson-${version}";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppx_deriving_yojson";
    rev = "v${version}";
    sha256 = "1pwfnq7z60nchba4gnf58918ll11w3gj5i88qhz1p2jm45hxqgnw";
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
