{ lib, buildPythonPackage, fetchPypi, isPy3k, requests }:

buildPythonPackage rec {
  pname = "pynanoleaf";
  version = "0.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ced000e3c37f4e2ce0ea177d924af71c97007de9e4fd0ef37dcd7b4a6d1b622";
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
