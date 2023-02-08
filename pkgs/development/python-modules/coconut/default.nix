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
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = "coconut";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-zDMcQPAYlxid3fcMT8kRzE+LN1dxUVWjkg8pdVtmwZg=";
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
