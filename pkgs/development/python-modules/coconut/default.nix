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
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = "coconut";
    rev = "refs/tags/v${version}";
    hash = "sha256-+OrVNtre7kAfU5L7/6DadZxFNWVt5raF6HLGXHHpOvE=";
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
