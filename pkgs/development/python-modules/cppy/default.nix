{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "cppy";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-leiGLk+CbD8qa3tlgzOxYvgMvp+UOqDQp6ay74UK7/w=";
  };

  # Headers-only library, no tests
  doCheck = false;

  # Not supported
  disabled = !isPy3k;

  meta = {
    description = "C++ headers for C extension development";
    homepage = "https://github.com/nucleic/cppy";
    license = lib.licenses.bsd3;
  };
}
