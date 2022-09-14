{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-check";
  version = "1.0.9";
  format = "flit";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zVMQTzpPw2RPcCi1XiOHZvbWWhKiB9MbzUyLoA2yP9k=";
  };

  buildInputs = [
    pytest
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "pytest plugin allowing multiple failures per test";
    homepage = "https://github.com/okken/pytest-check";
    license = licenses.mit;
    maintainers = [ maintainers.flokli ];
  };
}
