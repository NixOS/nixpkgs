{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "process-tests";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5dV96nFhJR6RytuEvz7MhSdfsSH9R45Xn4AHd7HUJL0=";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Tools for testing processes";
    license = licenses.bsd2;
    homepage = "https://github.com/ionelmc/python-process-tests";
  };

}
