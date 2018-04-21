{ stdenv, jbuilder, ocaml, findlib, lwt, ppx_tools_versioned }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-lwt_ppx-${lwt.version}";

  inherit (lwt) src;

  buildInputs = [ jbuilder ocaml findlib ppx_tools_versioned ];

  propagatedBuildInputs = [ lwt ];

  buildPhase = "jbuilder build -p lwt_ppx";
  installPhase = "${jbuilder.installPhase} lwt_ppx.install";

  meta = {
    description = "Ppx syntax extension for Lwt";
    inherit (lwt.meta) license platforms homepage maintainers;
  };
}
