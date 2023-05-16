{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, importlib-metadata
, pytestCheckHook

<<<<<<< HEAD
  # large-rebuild downstream dependencies and applications
=======
# large-rebuild downstream dependencies and applications
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, flask
, black
, magic-wormhole
, mitmproxy
, typer
}:

buildPythonPackage rec {
  pname = "click";
<<<<<<< HEAD
  version = "8.1.6";
=======
  version = "8.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-SO6EmVGRlSegRb/jv3uqipWcQjE04aW5jAXCC6daHL0=";
=======
    hash = "sha256-doLcivswKXABZ0V16gDRgU2AjWo2r0Fagr1IHTe6e44=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru.tests = {
    inherit black flask magic-wormhole mitmproxy typer;
  };

  meta = with lib; {
    homepage = "https://click.palletsprojects.com/";
    description = "Create beautiful command line interfaces in Python";
    longDescription = ''
      A Python package for creating beautiful command line interfaces in a
      composable way, with as little code as necessary.
    '';
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ nickcao ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
