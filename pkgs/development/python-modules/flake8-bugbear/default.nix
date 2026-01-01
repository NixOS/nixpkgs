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
<<<<<<< HEAD
  version = "25.11.29";
=======
  version = "25.10.21";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "flake8-bugbear";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-aIcLCUUiXVzt9aDllXmm0TqIDxwTa3zcs6Yc2H5LnWY=";
=======
    hash = "sha256-4ZTi1w+L0M6LCB4G+OxHBnUV0f6s/JPY6tKOt1zh7So=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Plugin for Flake8 to find bugs and design problems";
    homepage = "https://github.com/PyCQA/flake8-bugbear";
    changelog = "https://github.com/PyCQA/flake8-bugbear/blob/${src.tag}/README.rst#change-log";
    longDescription = ''
      A plugin for flake8 finding likely bugs and design problems in your
      program.
    '';
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ newam ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
