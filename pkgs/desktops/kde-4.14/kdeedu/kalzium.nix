{ kde, kdelibs, facile, ocaml, eigen2, eigen, openbabel, avogadro, pkgconfig }:
kde {

# TODO: chemical mime data

  buildInputs = [ kdelibs facile ocaml eigen2 eigen openbabel avogadro ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Periodic Table of Elements";
  };
}
