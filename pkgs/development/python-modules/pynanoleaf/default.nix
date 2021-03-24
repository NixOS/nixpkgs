{ lib, buildPythonPackage, fetchPypi, isPy3k, requests }:

buildPythonPackage rec {
  pname = "pynanoleaf";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0622c982c7b2ee420878de7e08a2a7ad30766d228c3446de30bc068b62d12dc8";
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
