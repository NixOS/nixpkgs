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
  version = "0.2.20220601";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zBCYPcqgsyYKTNHAfHrcH6aWfbz6zJwajxHkwRjHeQU=";
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
