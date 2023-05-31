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
  version = "3.11.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TqrrGu+jk6WNXUnXJao71JHEu7Is27UeHAG29/Jpqb8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    gobject-introspection
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
