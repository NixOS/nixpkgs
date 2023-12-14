{ lib, buildPythonPackage, fetchPypi, isPy3k, requests }:

buildPythonPackage rec {
  pname = "pynanoleaf";
  version = "0.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "32a083759c4f99e019e0013670487841f8edf807c7a07742a971fa18707072a7";
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
