{ lib
, buildPythonPackage
, fetchPypi
, setuptools
<<<<<<< HEAD
, wheel
=======
, nose
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, parts
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "bitlist";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-+/rBno+OH7yEiN4K9VC6BCEPuOv8nNp0hU+fWegjqPw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '--cov=bitlist --cov-report term-missing' ""
  '';

  nativeBuildInputs = [
    setuptools
    wheel
=======
    hash = "sha256-eViakuhgSe9E8ltxzeg8m6/ze7QQvoKBtYZoBZzHxlA=";
  };

  nativeBuildInputs = [
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    parts
  ];

  nativeCheckInputs = [
    pytestCheckHook
<<<<<<< HEAD
=======
    nose
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "bitlist"
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--doctest-modules --ignore=docs --cov=bitlist --cov-report term-missing" ""
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Python library for working with little-endian list representation of bit strings";
    homepage = "https://github.com/lapets/bitlist";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
