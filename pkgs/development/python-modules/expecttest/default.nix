{ lib
, buildPythonPackage
, fetchFromGitHub

# Native build inputs
, poetry-core

# Check inputs
, pytestCheckHook
, hypothesis
}:

buildPythonPackage rec {
  pname = "expecttest";
  version = "0.1.3";
  format = "pyproject";

  # Pypi doesn't contain the test, so fetch from GitHub
  src = fetchFromGitHub {
    owner = "ezyang";
    repo = "expecttest";
    rev = "1450e7fc26d5a55a2efb8cca93b0f193a259d8e1";
    sha256 = "sha256:07dgbkjiwxi0jvmrgglyrfxk3jqvmnv66fmd05f72zwvaiafjag4";
  };

  nativeBuildInputs = [ poetry-core ];

  checkInputs = [
    pytestCheckHook
    hypothesis
  ];

  pytestFlagsArray = [
    "test_expecttest.py"
  ];

  pythonImportsCheck = [ "expecttest" ];

  meta = with lib; {
    description = "Module which implements expect tests";
    homepage = "https://github.com/ezyang/expecttest";
    license = licenses.mit;
    maintainers = with maintainers; [  ];
  };
}
