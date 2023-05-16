{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, poetry-core
, gobject-introspection
, gtk3
, pycairo
, pygobject3
, typing-extensions
}:

buildPythonPackage rec {
  pname = "gaphas";
<<<<<<< HEAD
  version = "3.11.3";
=======
  version = "3.10.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-NpmNIwZqvWAJDkUEb6+GpfQaRCVtjQk4odkaOd2D2ok=";
=======
    hash = "sha256-I+/DsXppY//KOZgydDR4/Ks5qEsL4hLIiH+GaaFZHpA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
<<<<<<< HEAD
    gobject-introspection
  ];

  buildInputs = [
=======
  ];

  buildInputs = [
    gobject-introspection
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    gtk3
  ];

  propagatedBuildInputs = [
    pycairo
    pygobject3
    typing-extensions
  ];

  pythonImportsCheck = [
    "gaphas"
  ];

  meta = with lib; {
    description = "GTK+ based diagramming widget";
    homepage = "https://github.com/gaphor/gaphas";
    changelog = "https://github.com/gaphor/gaphas/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
