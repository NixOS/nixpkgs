{ lib
, buildPythonPackage
, coverage
, fetchPypi
, isPyPy
, isPy311
, python
, pythonAtLeast
, stdenv
}:

buildPythonPackage rec {
  pname = "nose3";
  version = "1.3.8";
  format = "setuptools";

  # https://github.com/jayvdb/nose3/issues/5
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-diquIsrbiYsAudT0u7n46H+ODd5sSaiM0MVU9OWSW3Y=";
  };

  propagatedBuildInputs = [ coverage ];

  # PyPy hangs for unknwon reason
  # Darwin and python 3.11 fail at various assertions and I didn't find an easy way to find skip those tests
  doCheck = !isPyPy && !stdenv.isDarwin && !isPy311;

  checkPhase = ''
    ${python.pythonOnBuildForHost.interpreter} selftest.py
  '';

  meta = with lib; {
    description = "Fork of nose v1 not using lib2to3 for compatibility with Python 3";
    homepage = "https://github.com/jayvdb/nose3";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
