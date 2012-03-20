{ kde, cmake, smokeqt, kdelibs, akonadi, kdepimlibs, shared_desktop_ontologies, attica }:

kde {
  buildInputs = [ smokeqt kdelibs akonadi kdepimlibs shared_desktop_ontologies attica ];
  buildNativeInputs = [ cmake ];

  cmakeFlags = "-DQTDEFINES_FILE=${smokeqt}/share/smokegen/qtdefines";
  meta = {
    description = "SMOKE bindings for kdelibs";
  };
}
