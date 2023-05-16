{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pythonOlder
, pytestCheckHook
=======
, fetchpatch
, python
, pythonOlder
, pytest
, unittestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "mock";
<<<<<<< HEAD
  version = "5.1.0";
=======
  version = "4.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    sha256 = "sha256-Xpaq1czaRxjgointlLICTfdcwtVVdbpXYtMfV2e4dn0=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mock"
  ];

  meta = with lib; {
    description = "Rolling backport of unittest.mock for all Pythons";
    homepage = "https://github.com/testing-cabal/mock";
    changelog = "https://github.com/testing-cabal/mock/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd2;
    maintainers = [ ];
=======
    sha256 = "7d3fbbde18228f4ff2f1f119a45cdffa458b4c0dee32eb4d2bb2f82554bac7bc";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/testing-cabal/mock/commit/f3e3d82aab0ede7e25273806dc0505574d85eae2.patch";
      hash = "sha256-wPrv1/WeICZHn31UqFlICFsny2knvn3+Xg8BZoaGbwQ=";
    })
  ];

  nativeCheckInputs = [
    unittestCheckHook
    pytest
  ];

  meta = with lib; {
    description = "Mock objects for Python";
    homepage = "https://github.com/testing-cabal/mock";
    license = licenses.bsd2;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
