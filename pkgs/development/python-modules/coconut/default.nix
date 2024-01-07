{ lib
, buildPythonPackage
, fetchFromGitHub
, cpyparsing
, ipykernel
, mypy
, pexpect
, pygments
, pytestCheckHook
, prompt-toolkit
, tkinter
, watchdog
}:

buildPythonPackage rec {
  pname = "coconut";
  version = "3.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = "coconut";
    rev = "refs/tags/v${version}";
    hash = "sha256-u1tcIu0U1VZrUx2hVdtRDv1N4jVf176kQSw47/7lOXY=";
  };

  propagatedBuildInputs = [ cpyparsing ipykernel mypy pygments prompt-toolkit watchdog ];

  nativeCheckInputs = [ pexpect pytestCheckHook tkinter ];

  # Currently most tests have performance issues
  pytestFlagsArray = [
    "coconut/tests/constants_test.py"
  ];

  pythonImportsCheck = [ "coconut" ];

  meta = with lib; {
    homepage = "http://coconut-lang.org/";
    description = "Simple, elegant, Pythonic functional programming";
    license = licenses.asl20;
    maintainers = with maintainers; [ fabianhjr ];
  };
}
