{ kde, kdelibs, facile, ocaml, eigen, openbabel, avogadro, pkgconfig }:
kde {

# TODO: chemical mime data

  buildInputs = [ kdelibs facile ocaml eigen openbabel avogadro ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Periodic Table of Elements";
  };
}
