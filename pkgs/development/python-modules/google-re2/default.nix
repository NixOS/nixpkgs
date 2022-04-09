{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pybind11
, re2
, six
}:

buildPythonPackage rec {
  pname = "google-re2";
  version = "0.2.20220401";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v3G+MvFV8gq9LJqj/zrtlTjRm0ZNxTh0UdQSPiwFHY4=";
  };

  propagatedBuildInputs = [
    pybind11
    re2
    six
  ];

  pythonImportsCheck = [
    "re2"
  ];

  meta = with lib; {
    description = "RE2 Python bindings";
    homepage = "https://github.com/google/re2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alexbakker ];
  };
}
