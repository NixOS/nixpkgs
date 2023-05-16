{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, fetchpatch
, pytest
, pytest-asyncio
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-mock";
<<<<<<< HEAD
  version = "3.11.1";
=======
  version = "3.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-f2sSVgKsbXQ+Ujrgv6ceGml6L1U0BkUoxv+EwvfC/H8=";
  };

=======
    hash = "sha256-+72whe98JSoyb9jNysCqOxMz2IEfExvcxwEALhvn7U8=";
  };

  patches = [
    (fetchpatch {
      # Remove unnecessary py.code import
      url = "https://github.com/pytest-dev/pytest-mock/pull/328/commits/e2016928db1147a2a46de6ee9fa878ca0e9d8fc8.patch";
      hash = "sha256-5Gpzi7h7Io1CMykmBCZR/upM8E9isc3jEItYgwjEOWA=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_mock" ];

  meta = with lib; {
    description = "Thin wrapper around the mock package for easier use with pytest";
    homepage = "https://github.com/pytest-dev/pytest-mock";
    changelog = "https://github.com/pytest-dev/pytest-mock/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
