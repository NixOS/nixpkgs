{ stdenv, dune, ocaml, findlib, lwt, ppx_tools_versioned }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-lwt_ppx-${lwt.version}";

  inherit (lwt) src;

  buildInputs = [ dune ocaml findlib ppx_tools_versioned ];

  propagatedBuildInputs = [ lwt ];

  buildPhase = "dune build -p lwt_ppx";
  installPhase = "${dune.installPhase} lwt_ppx.install";

  meta = {
    description = "Ppx syntax extension for Lwt";
    inherit (lwt.meta) license platforms homepage maintainers;
  };
}
