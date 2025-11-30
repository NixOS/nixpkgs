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
  setuptools,
}:

buildPythonPackage rec {
  pname = "flake8-bugbear";
  version = "25.11.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "flake8-bugbear";
    tag = version;
    hash = "sha256-aIcLCUUiXVzt9aDllXmm0TqIDxwTa3zcs6Yc2H5LnWY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    attrs
    flake8
  ];

  nativeCheckInputs = [
    flake8
    pytestCheckHook
    hypothesis
    hypothesmith
  ];

  pythonImportsCheck = [ "bugbear" ];

  meta = with lib; {
    description = "Plugin for Flake8 to find bugs and design problems";
    homepage = "https://github.com/PyCQA/flake8-bugbear";
    changelog = "https://github.com/PyCQA/flake8-bugbear/blob/${src.tag}/README.rst#change-log";
    longDescription = ''
      A plugin for flake8 finding likely bugs and design problems in your
      program.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}
