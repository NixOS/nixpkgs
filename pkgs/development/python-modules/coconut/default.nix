{
  lib,
  anyio,
  async-generator,
  buildPythonPackage,
  fetchFromGitHub,
  cpyparsing,
  ipykernel,
  mypy,
  pexpect,
  pygments,
  pytestCheckHook,
  prompt-toolkit,
  setuptools,
  tkinter,
  watchdog,
}:

buildPythonPackage rec {
  pname = "coconut";
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "evhub";
    repo = "coconut";
    rev = "refs/tags/v${version}";
    hash = "sha256-Vd6ZY3PlbPOy63/0/0YJ1U2PpsVdctOoInyKftj//cM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    anyio
    async-generator
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
  pytestFlagsArray = [ "coconut/tests/constants_test.py" ];

  pythonImportsCheck = [ "coconut" ];

  meta = with lib; {
    description = "Simple, elegant, Pythonic functional programming";
    homepage = "http://coconut-lang.org/";
    changelog = "https://github.com/evhub/coconut/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fabianhjr ];
  };
}
