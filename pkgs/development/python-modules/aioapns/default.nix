{ buildPythonPackage
, fetchPypi
, setuptools
, h2
, lib
, pyjwt
, pyopenssl
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioapns";
<<<<<<< HEAD
  version = "3.0";
=======
  version = "2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-MiFjd9HYaTugjP66O24Tgk92bC91GQHggvy1sdQIu+0=";
=======
    hash = "sha256-3FMNIhIZrstPKTfHVmN+K28UR2G26HZ5S/JtXmaFk1c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    h2
    pyopenssl
    pyjwt
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioapns" ];

  meta = with lib; {
    description = "An efficient APNs Client Library for Python/asyncio";
    homepage = "https://github.com/Fatal1ty/aioapns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
