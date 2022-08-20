{ lib, buildPythonPackage, fetchPypi
, pytestCheckHook
, pytest-mypy
, redis
}:

buildPythonPackage rec {
  version = "2.5.1";
  pname = "portalocker";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ro6cwmYNoEv0H6Gg7vfjALteSlhprfsabYVRYytVmys=";
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
