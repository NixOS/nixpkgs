{ kde, kdelibs, facile, ocaml, eigen, openbabel, avogadro }:
kde {
  buildInputs = [ kdelibs facile ocaml eigen openbabel avogadro ];

  patches = [ ./kalzium-find-libfacile.patch ];

  meta = {
    description = "Periodic Table of Elements";
  };
}
