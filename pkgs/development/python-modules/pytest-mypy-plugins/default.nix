{ lib
, buildPythonPackage
, chevron
, decorator
, fetchFromGitHub
, mypy
, pytest
, pytestCheckHook
, pythonOlder
, pyyaml
, regex
}:

buildPythonPackage rec {
  pname = "pytest-mypy-plugins";
  version = "1.9.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "typeddjango";
    repo = pname;
    rev = version;
    sha256 = "sha256-4hG3atahb+dH2dRGAxguJW3vvEf0TUGUJ3G5ymrf3Vg=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    chevron
    pyyaml
    mypy
    decorator
    regex
  ];

  checkInputs = [
    mypy
    pytestCheckHook
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  pythonImportsCheck = [
    "pytest_mypy_plugins"
  ];

  meta = with lib; {
    description = "Pytest plugin for testing mypy types, stubs, and plugins";
    homepage = "https://github.com/TypedDjango/pytest-mypy-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
