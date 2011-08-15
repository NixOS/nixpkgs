{ kde, kdelibs, facile, ocaml, eigen, openbabel, avogadro }:
kde {
  buildInputs = [ kdelibs facile ocaml eigen openbabel avogadro ];

  prePatch = ''
    cp -v ${./FindLibfacile.cmake} cmake/modules/FindLibfacile.cmake
    sed -e 's/\+facile/''${LIBFACILE_INCLUDE_DIR}/' -i src/CMakeOCamlInstructions.cmake
    '';

  patches = [ ./kalzium-feature-log.patch ];

  meta = {
    description = "Periodic Table of Elements";
  };
}
