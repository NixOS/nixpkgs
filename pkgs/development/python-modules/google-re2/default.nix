{ lib, buildPythonPackage, pythonOlder, fetchPypi, pybind11, re2, six }:

buildPythonPackage rec {
  pname = "google-re2";
  version = "0.2.20210801";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0806d78691e67970b3761767a30f1c631fed85b87001266c6adcb672ac2c9beb";
  };

  propagatedBuildInputs = [
    pybind11 re2 six
  ];

  meta = with lib; {
    description = "RE2 Python bindings";
    homepage    = "https://github.com/google/re2";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ alexbakker ];
  };
}
