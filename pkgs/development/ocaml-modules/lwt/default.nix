{ lib, fetchzip, pkgconfig, ncurses, libev, buildDunePackage, ocaml
, cppo, ocaml-migrate-parsetree, ocplib-endian, result
, mmap, seq
}:

let inherit (lib) optional versionAtLeast; in

buildDunePackage rec {
  pname = "lwt";
  version = "5.3.0";

  src = fetchzip {
    url = "https://github.com/ocsigen/${pname}/archive/${version}.tar.gz";
    sha256 = "15hgy3220m2b8imipa514n7l65m1h5lc6l1hanqwwvs7ghh2aqp2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cppo ocaml-migrate-parsetree ]
   ++ optional (!versionAtLeast ocaml.version "4.07") ncurses;
  propagatedBuildInputs = [ libev mmap ocplib-endian seq result ];

  meta = {
    homepage = "https://ocsigen.org/lwt/";
    description = "A cooperative threads library for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
