{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  lib,
  setuptools,
  attrs,
  requests,
  fetchPypi,
  pytest-cov,
  pytestCheckHook,
  vcrpy,
  ...
}:
let
  setuptools-scm-83 = (
    setuptools-scm.overridePythonAttrs (_: {
      version = "8.3.1";
      src = fetchPypi {
        pname = "setuptools_scm";
        version = "8.3.1";
        hash = "sha256-PVVekrddrNA30yuv35T5evUeoprox7I0z5S3pb0kKmM=";
      };
    })
  );
in
buildPythonPackage (finalAttrs: {
  pname = "bioutils";
  version = "0.6.1";
  src = fetchFromGitHub {
    owner = "biocommons";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-svkTjf9I1vHU8ZvEqIYuiS77+OLpEQbzfMrxDeSX5bg=";
  };
  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm-83
  ];

  dependencies = [
    attrs
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
    vcrpy
  ];

  disabledTestMarks = [ "network" ];

  pythonImportsCheck = [ "bioutils" ];

  meta = {
    changelog = "https://github.com/biocommons/bioutils/releases/tag/${finalAttrs.src.tag}";
    description = "bioutils provides some common utilities and lookup tables for bioinformatics.";
    homepage = "https://biocommons.org/en/latest/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rub-br ];
  };
})
