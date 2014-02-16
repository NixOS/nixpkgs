{ kde, cmake, smokeqt, kdelibs, akonadi, kdepimlibs, okular
, shared_desktop_ontologies, attica, pkgconfig }:

kde {

  # TODO: attica, akonadi and kdepimlibs are disabled due to smokegen crash
  # okular is disabled because the code generated is broken
  buildInputs = [
    smokeqt kdelibs shared_desktop_ontologies
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  LD_LIBRARY_PATH = "${smokeqt}/lib/";

  meta = {
    description = "SMOKE bindings for kdelibs";
  };
}
