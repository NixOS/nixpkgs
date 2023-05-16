{ lib
, bitlist
, buildPythonPackage
, fetchPypi
, fountains
, parts
, pytestCheckHook
, pythonOlder
, setuptools
<<<<<<< HEAD
, wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "fe25519";
<<<<<<< HEAD
  version = "1.5.0";
=======
  version = "1.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-la+17tPHjceMTe7Wk8DGVaSptk8XJa+l7GTeqLIFDvs=";
=======
    hash = "sha256-VwCw/sS8Pzhscoa6yCRGbB9X+CtRVn8xyBEpKfGyhhY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
<<<<<<< HEAD
    wheel
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    bitlist
    fountains
    parts
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--doctest-modules --ignore=docs --cov=fe25519 --cov-report term-missing" ""
  '';

  pythonImportsCheck = [
    "fe25519"
  ];

  meta = with lib; {
    description = "Python field operations for Curve25519's prime";
    homepage = "https://github.com/BjoernMHaase/fe25519";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
  };
}
