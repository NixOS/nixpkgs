{ kde, cmake, smokeqt, kdelibs, akonadi, kdepimlibs, okular
, shared_desktop_ontologies, attica, nepomuk_core }:

kde {
  # attica, akonadi and kdepimlibs are disabled due to smokegen crash
  # okular is disabled because the code generated is broken
  buildInputs = [
    smokeqt kdelibs shared_desktop_ontologies
  ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = "-DQTDEFINES_FILE=${smokeqt}/share/smokegen/qtdefines";
  meta = {
    description = "SMOKE bindings for kdelibs";
  };
}
