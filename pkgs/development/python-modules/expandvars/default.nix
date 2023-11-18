{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "expandvars";
  version = "0.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q7Qn9dMnqzYAY98mFR+Y0qbwj+GPKJWjKn9fDxF7W1I=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  # The PyPi package does not supply any tests
  doCheck = false;

  pythonImportsCheck = [
    "expandvars"
  ];

  meta = with lib; {
    description = "Expand system variables Unix style";
    homepage = "https://github.com/sayanarijit/expandvars";
    license = licenses.mit;
    maintainers = with maintainers; [ geluk ];
  };
}
