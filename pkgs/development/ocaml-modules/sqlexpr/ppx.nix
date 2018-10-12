{ stdenv, ocaml, findlib, dune, sqlexpr, ounit
, ppx_core, ppx_tools_versioned, re, lwt_ppx
}:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ppx_sqlexpr-${version}";
  inherit (sqlexpr) version src installPhase meta;

  buildInputs = [ ocaml findlib dune sqlexpr ounit ppx_core ppx_tools_versioned re lwt_ppx ];

  buildPhase = "dune build -p ppx_sqlexpr";

  doCheck = true;
  checkPhase = "dune runtest -p ppx_sqlexpr";
}
