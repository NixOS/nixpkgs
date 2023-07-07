{ lib
, buildPythonPackage
, fetchPypi
, autoconf
, cython
, setuptools
}:

buildPythonPackage rec {
  pname = "dtlssocket";
  version = "0.1.15";

  format = "pyproject";

  src = fetchPypi {
    pname = "DTLSSocket";
    inherit version;
    hash = "sha256-RWscUxJsmLkI2GPjnpS1oJVPsJ+xbqPAKk4Q1G7ISu4=";
  };

  nativeBuildInputs = [
    autoconf
    cython
    setuptools
  ];

  # no tests on PyPI, no tags on GitLab
  doCheck = false;

  pythonImportsCheck = [ "DTLSSocket" ];

  meta = with lib; {
    description = "Cython wrapper for tinydtls with a Socket like interface";
    homepage = "https://git.fslab.de/jkonra2m/tinydtls-cython";
    license = licenses.epl10;
    maintainers = with maintainers; [ dotlambda ];
  };
}
