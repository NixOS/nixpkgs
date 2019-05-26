{ stdenv, fetchzip, pkgconfig, ncurses, libev, buildDunePackage, ocaml
, cppo, ocaml-migrate-parsetree, ppx_tools_versioned, result
}:

let inherit (stdenv.lib) optional versionAtLeast; in

buildDunePackage rec {
  pname = "lwt";
  version = "4.1.0";

  src = fetchzip {
    url = "https://github.com/ocsigen/${pname}/archive/${version}.tar.gz";
    sha256 = "16wnc61kfj54z4q8sn9f5iik37pswz328hcz3z6rkza3kh3s6wmm";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cppo ocaml-migrate-parsetree ppx_tools_versioned ]
   ++ optional (!versionAtLeast ocaml.version "4.07") ncurses;
  propagatedBuildInputs = [ libev result ];

  configurePhase = "ocaml src/util/configure.ml -use-libev true";

  meta = {
    homepage = "https://ocsigen.org/lwt/";
    description = "A cooperative threads library for OCaml";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.lgpl21;
  };
}
