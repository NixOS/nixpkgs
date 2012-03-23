{ kde, cmake, smokeqt, kdelibs, akonadi, kdepimlibs, shared_desktop_ontologies, attica }:

kde {
  # attica, akonadi and kdepimlibs are disabled due to smokegen crash
  buildInputs = [ smokeqt kdelibs shared_desktop_ontologies ];
  buildNativeInputs = [ cmake ];

  cmakeFlags = "-DQTDEFINES_FILE=${smokeqt}/share/smokegen/qtdefines";
  meta = {
    description = "SMOKE bindings for kdelibs";
  };
}
