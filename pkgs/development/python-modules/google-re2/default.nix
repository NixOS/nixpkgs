{ lib, buildPythonPackage, pythonOlder, fetchPypi, pybind11, re2, six }:

buildPythonPackage rec {
  pname = "google-re2";
  version = "0.2.20211101";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "305dc0f749c1abad51f8dc59b49b98a58dc06b976727f6b711c87c01944046d9";
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
