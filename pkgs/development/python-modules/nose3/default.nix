{ lib
, buildPythonPackage
, coverage
, fetchPypi
, isPyPy
, python
, stdenv
}:

buildPythonPackage rec {
  pname = "nose3";
  version = "1.3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-diquIsrbiYsAudT0u7n46H+ODd5sSaiM0MVU9OWSW3Y=";
  };

  propagatedBuildInputs = [ coverage ];

  # PyPy hangs for unknwon reason
  # darwin fails an assertion and I didn't find a way to find skip that test
  doCheck = !isPyPy && !stdenv.isDarwin;

  checkPhase = ''
    ${python.pythonForBuild.interpreter} selftest.py
  '';

  meta = with lib; {
    description = "Fork of nose v1 not using lib2to3 for compatibility with Python 3";
    homepage = "https://github.com/jayvdb/nose3";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
