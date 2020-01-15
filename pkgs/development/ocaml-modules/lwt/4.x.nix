{ lib, fetchzip, pkgconfig, ncurses, libev, buildDunePackage, ocaml
, cppo, ocaml-migrate-parsetree, ppx_tools_versioned, result
, mmap, seq
}:

let inherit (lib) optional versionAtLeast; in

buildDunePackage rec {
  pname = "lwt";
  version = "4.2.1";

  src = fetchzip {
    url = "https://github.com/ocsigen/${pname}/archive/${version}.tar.gz";
    sha256 = "1hz24fyhpm7d6603v399pgxvdl236srwagqja41ljvjx83y10ysr";
  };

  postPatch = ''
    substituteInPlace lwt.opam \
    --replace 'version: "dev"' 'version: "${version}"'
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cppo ocaml-migrate-parsetree ppx_tools_versioned ]
   ++ optional (!versionAtLeast ocaml.version "4.07") ncurses;
  propagatedBuildInputs = [ libev mmap seq result ];

  meta = {
    homepage = "https://ocsigen.org/lwt/";
    description = "A cooperative threads library for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
