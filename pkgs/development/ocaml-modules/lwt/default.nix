{ lib, fetchzip, pkg-config, ncurses, libev, buildDunePackage, ocaml
, cppo, dune-configurator, ocaml-migrate-parsetree, ocplib-endian, result
, mmap, seq
, ocaml-syntax-shims
}:

let inherit (lib) optional versionAtLeast; in

buildDunePackage rec {
  pname = "lwt";
  version = "5.4.0";

  useDune2 = true;

  src = fetchzip {
    url = "https://github.com/ocsigen/${pname}/archive/${version}.tar.gz";
    sha256 = "1ay1zgadnw19r9hl2awfjr22n37l7rzxd9v73pjbahavwm2ay65d";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ cppo dune-configurator ocaml-migrate-parsetree ]
   ++ optional (!versionAtLeast ocaml.version "4.08") ocaml-syntax-shims
   ++ optional (!versionAtLeast ocaml.version "4.07") ncurses;
  propagatedBuildInputs = [ libev mmap ocplib-endian seq result ];

  meta = {
    homepage = "https://ocsigen.org/lwt/";
    description = "A cooperative threads library for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.mit;
  };
}
