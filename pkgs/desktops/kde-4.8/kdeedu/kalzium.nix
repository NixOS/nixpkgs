{ kde, kdelibs, facile, ocaml, eigen, openbabel, avogadro }:
kde {
  buildInputs = [ kdelibs facile ocaml eigen openbabel avogadro ];

  meta = {
    description = "Periodic Table of Elements";
  };
}
