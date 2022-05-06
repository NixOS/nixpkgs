{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, importlib-metadata
, pytestCheckHook

# large-rebuild downstream dependencies
, flask
, black

# applications
, magic-wormhole
, mitmproxy
}:

buildPythonPackage rec {
  pname = "click";
  version = "8.1.2";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-R5cH/hTZ7JoHV2GLehAKCuTE4jb6xbf4DKaAKBQaGnI=";
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
