{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "looseversion";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "flit";

  src = fetchPypi {
    inherit version pname;
<<<<<<< HEAD
    sha256 = "sha256-695l8/a7lTGoEBbG/vPrlaYRga3Ee3+UnpwOpHkRZp4=";
=======
    sha256 = "sha256-lNgL29C21XwRuIYUe6FgH30VMVcWIbgZM7NFN8vkaa0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];
  pytestFlagsArray = [ "tests.py" ];
  pythonImportsCheck = [ "looseversion" ];

  meta = with lib; {
    description = "Version numbering for anarchists and software realists";
    homepage = "https://github.com/effigies/looseversion";
    license = licenses.psfl;
    maintainers = with maintainers; [ pelme ];
  };
}
