{ stdenv, fetchzip, pkgconfig, ncurses, libev, dune
, ocaml, findlib, cppo
, ocaml-migrate-parsetree, ppx_tools_versioned, result
}:

let inherit (stdenv.lib) optional versionAtLeast; in

stdenv.mkDerivation rec {
  version = "4.1.0";
  name = "ocaml${ocaml.version}-lwt-${version}";

  src = fetchzip {
    url = "https://github.com/ocsigen/lwt/archive/${version}.tar.gz";
    sha256 = "16wnc61kfj54z4q8sn9f5iik37pswz328hcz3z6rkza3kh3s6wmm";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ocaml findlib dune cppo
    ocaml-migrate-parsetree ppx_tools_versioned
  ] ++ optional (!versionAtLeast ocaml.version "4.07") ncurses;
  propagatedBuildInputs = [ libev result ];

  configurePhase = "ocaml src/util/configure.ml -use-libev true";
  buildPhase = "jbuilder build -p lwt";
  inherit (dune) installPhase;

  meta = {
    homepage = "https://ocsigen.org/lwt/";
    description = "A cooperative threads library for OCaml";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.lgpl21;
    inherit (ocaml.meta) platforms;
  };
}

