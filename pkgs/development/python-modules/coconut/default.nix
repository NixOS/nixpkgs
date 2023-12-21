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
, setuptools
, tkinter
, watchdog
}:

buildPythonPackage rec {
  pname = "coconut";
  version = "3.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "evhub";
    repo = "coconut";
    rev = "refs/tags/v${version}";
    hash = "sha256-TIYep9EuCfcN8bp0vkaoB5W626lrD4PVh+oYKmVrfeY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cpyparsing
    ipykernel
    mypy
    pygments
    prompt-toolkit
    setuptools
    watchdog
  ];

  nativeCheckInputs = [
    pexpect
    pytestCheckHook
    tkinter
  ];

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
