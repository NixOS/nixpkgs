{ lib, buildPythonPackage, fetchPypi, isPy3k, requests }:

buildPythonPackage rec {
  pname = "pynanoleaf";
  version = "0.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7d212f35eac9d94248858ec63ca63545ea7fce1cdda11ae5878f4d4d74f055d0";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ requests ];

  # pynanoleaf does not contain tests
  doCheck = false;

  pythonImportsCheck = [
    "pynanoleaf"
  ];

  meta = with lib; {
    homepage = "https://github.com/Oro/pynanoleaf";
    description = "A Python3 wrapper for the Nanoleaf API, capable of controlling both Nanoleaf Aurora and Nanoleaf Canvas";
    license = licenses.mit;
    maintainers = with maintainers; [ oro ];
  };
}
