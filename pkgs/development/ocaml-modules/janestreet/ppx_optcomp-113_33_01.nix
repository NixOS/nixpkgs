{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, opam, topkg, oasis
, ppx_core, ppx_tools
}:

let
  param = {
    "4.03" = {
      version = "113.33.00+4.03";
      sha256 = "1fkz6n40l4ck8bcr548d2yp08zc9fjv42zldlh0cj3ammhiz3gap";
    };
    "4.04" = {
      version = "113.33.01+4.03";
      sha256 = "1caw5dfgh5rw8mcgar0hdn485j1rqlnkbfb8wd0wdl5zhkg8jk3d";
    };
  }."${ocaml.meta.branch}";
in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ppx_optcomp-${param.version}";
  src = fetchzip {
    url = "http://github.com/janestreet/ppx_optcomp/archive/${param.version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [ ocaml findlib ocamlbuild opam oasis ppx_tools ];
  propagatedBuildInputs = [ ppx_core ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
