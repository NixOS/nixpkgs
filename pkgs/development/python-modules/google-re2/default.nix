{ lib, buildPythonPackage, pythonOlder, fetchPypi, pybind11, re2, six }:

buildPythonPackage rec {
  pname = "google-re2";
  version = "0.2.20210901";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "676fa9ee54e3fb70f290526fc0f4d78d1e5a4add701b5547494eaf7c68c72247";
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
