{ lib, buildPythonPackage, pythonOlder, fetchPypi, pybind11, re2, six }:

buildPythonPackage rec {
  pname = "google-re2";
  version = "0.2.20220201";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-H8eMC1dM+9ukuRIN4uWWs7oRuQ0tpGaCwaCl0tp+lE8=";
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
