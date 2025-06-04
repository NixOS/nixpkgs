{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  attrs,
  flake8,
  pytestCheckHook,
  pythonOlder,
  hypothesis,
  hypothesmith,
}:

buildPythonPackage rec {
  pname = "flake8-bugbear";
  version = "24.12.12";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "flake8-bugbear";
    tag = version;
    hash = "sha256-ZMIpQUF+aXiq2NG0v19UwhWszrW/l50aJmG4YDV0+Wg=";
  };

  propagatedBuildInputs = [
    attrs
    flake8
  ];

  nativeCheckInputs = [
    flake8
    pytestCheckHook
    hypothesis
    hypothesmith
  ];

  meta = with lib; {
    description = "Plugin for Flake8 to find bugs and design problems";
    homepage = "https://github.com/PyCQA/flake8-bugbear";
    changelog = "https://github.com/PyCQA/flake8-bugbear/blob/${version}/README.rst#change-log";
    longDescription = ''
      A plugin for flake8 finding likely bugs and design problems in your
      program.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}
