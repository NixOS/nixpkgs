{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest-mypy
, pythonOlder
, redis
}:

buildPythonPackage rec {
  pname = "portalocker";
  version = "2.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lk9oMPtCp0tdMrzpntN9gwjB19RN3xjz3Yn0aA3pezk=";
  };

  propagatedBuildInputs = [
    redis
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mypy
  ];

  disabledTests = [
    "test_combined" # no longer compatible with setuptools>=58
  ];

  pythonImportsCheck = [
    "portalocker"
  ];

  meta = with lib; {
    description = "A library to provide an easy API to file locking";
    homepage = "https://github.com/WoLpH/portalocker";
    license = licenses.psfl;
    maintainers = with maintainers; [ jonringer ];
    platforms = platforms.unix; # Windows has a dependency on pypiwin32
  };
}
