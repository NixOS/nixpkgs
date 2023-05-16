{ lib
, callPackage
, buildPythonPackage
, fetchPypi
, pythonOlder
<<<<<<< HEAD
, hatchling
=======
, setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "attrs";
<<<<<<< HEAD
  version = "23.1.0";
  disabled = pythonOlder "3.7";
=======
  version = "22.2.0";
  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-YnmDbVgVE6JvG/I1+azTM7yRFWg/FPfo+uRsmPxQ4BU=";
  };

  patches = [
    # hatch-vcs and hatch-fancy-pypi-readme depend on pytest, which depends on attrs
    ./remove-hatch-plugins.patch
  ];

  postPatch = ''
    substituteAllInPlace pyproject.toml
  '';

  nativeBuildInputs = [
    hatchling
=======
    hash = "sha256-ySJ7/C8BmTwD9o2zfR0VyWkBiDI8BnxkHxo1ylgYX5k=";
  };

  nativeBuildInputs = [
    setuptools
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  outputs = [
    "out"
    "testout"
  ];

  postInstall = ''
    # Install tests as the tests output.
    mkdir $testout
    cp -R conftest.py tests $testout
  '';

  pythonImportsCheck = [
    "attr"
  ];

  # pytest depends on attrs, so we can't do this out-of-the-box.
  # Instead, we do this as a passthru.tests test.
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Python attributes without boilerplate";
    homepage = "https://github.com/python-attrs/attrs";
<<<<<<< HEAD
    changelog = "https://github.com/python-attrs/attrs/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
