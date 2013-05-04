{ kde, kdelibs, facile, ocaml, eigen, openbabel, avogadro, pkgconfig }:
kde {
#todo:chemical mime data
  buildInputs = [ kdelibs facile ocaml eigen openbabel avogadro ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Periodic Table of Elements";
  };
}
