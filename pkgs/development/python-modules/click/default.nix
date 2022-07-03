{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, importlib-metadata
, pytestCheckHook

# large-rebuild downstream dependencies and applications
, flask
, black
, magic-wormhole
, mitmproxy
}:

buildPythonPackage rec {
  pname = "click";
  version = "8.1.3";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-doLcivswKXABZ0V16gDRgU2AjWo2r0Fagr1IHTe6e44=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
  ];

  passthru.tests = {
    inherit black flask magic-wormhole mitmproxy;
  };

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
