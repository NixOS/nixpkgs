{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, gobject-introspection
, gtk4
, pycairo
, pygobject3
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "gaphas";
  version = "4.0.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "gaphor";
    repo = "gaphas";
    rev = version;
    hash = "sha256-GvEa1plRA4LtmIxdRv2F20pAL+C21bVNsJ+FCKVSwYw=";
  };

  nativeBuildInputs = [
    poetry-core
    # Solves ValueError: Namespace Gdk not available
    gobject-introspection
  ];

  buildInputs = [
    gtk4
  ];

  propagatedBuildInputs = [
    pycairo
    pygobject3
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # Getting a segmentation fault when running tests
  doCheck = false;

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
