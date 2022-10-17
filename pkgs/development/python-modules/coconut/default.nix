{ lib
, buildPythonApplication
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

buildPythonApplication rec {
  pname = "coconut";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = "coconut";
    rev = "v${version}";
    sha256 = "/397YGV6QWWmKfqr5hSvqRoPOu7Hx1Pak6rVPR3etzw=";
  };

  propagatedBuildInputs = [ cpyparsing ipykernel mypy pygments prompt-toolkit watchdog ];

  checkInputs = [ pexpect pytestCheckHook tkinter ];

  # Currently most tests have performance issues
  pytestFlagsArray = [
    "tests/constants_test.py"
  ];

  pythonImportsCheck = [ "coconut" ];

  meta = with lib; {
    homepage = "http://coconut-lang.org/";
    description = "Simple, elegant, Pythonic functional programming";
    license = licenses.asl20;
    maintainers = with maintainers; [ fabianhjr ];
  };
}
