{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, importlib-metadata
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "click";
  version = "8.1.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-l3whNHPHZl06oJK0H/EgYyJ3UcQdexcWUBPhAGnMXNI=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://click.palletsprojects.com/";
    description = "Create beautiful command line interfaces in Python";
    longDescription = ''
      A Python package for creating beautiful command line interfaces in a
      composable way, with as little code as necessary.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
