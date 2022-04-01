{ lib, buildPythonPackage, pythonOlder, fetchPypi, pybind11, re2, six }:

buildPythonPackage rec {
  pname = "google-re2";
  version = "0.2.20220401";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-v3G+MvFV8gq9LJqj/zrtlTjRm0ZNxTh0UdQSPiwFHY4=";
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
