{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  fastcore,
  numpy,
  plum-dispatch,
}:

buildPythonPackage (finalAttrs: {
  pname = "fasttransform";
  version = "0.0.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "fasttransform";
    tag = finalAttrs.version;
    hash = "sha256-d41645xOXkFv4rjFBfOXepYHGbYiCbHN2O30aePVVxM=";
  };

  # pkg_resources used to come with setuptools but was removed
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail \
        "from pkg_resources import parse_version" \
        "from packaging.version import parse as parse_version"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    fastcore
    numpy
    plum-dispatch
  ];

  pythonImportsCheck = [ "fasttransform" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Main building block of data pipelines in fastai";
    homepage = "https://github.com/AnswerDotAI/fasttransform";
    changelog = "https://github.com/AnswerDotAI/fasttransform/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
