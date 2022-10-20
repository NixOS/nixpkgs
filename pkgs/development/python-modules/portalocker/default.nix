{ lib, buildPythonPackage, fetchPypi
, pytestCheckHook
, pytest-mypy
, redis
}:

buildPythonPackage rec {
  version = "2.6.0";
  pname = "portalocker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lk9oMPtCp0tdMrzpntN9gwjB19RN3xjz3Yn0aA3pezk=";
  };

  propagatedBuildInputs = [
    redis
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mypy
  ];

  disabledTests = [
    "test_combined" # no longer compatible with setuptools>=58
  ];

  meta = with lib; {
    description = "A library to provide an easy API to file locking";
    homepage = "https://github.com/WoLpH/portalocker";
    license = licenses.psfl;
    maintainers = with maintainers; [ jonringer ];
    platforms = platforms.unix; # Windows has a dependency on pypiwin32
  };
}
