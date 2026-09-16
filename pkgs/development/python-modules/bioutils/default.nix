{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  lib,
  setuptools,
  attrs,
  requests,
  pytest-cov,
  pytestCheckHook,
  vcrpy,
}:
buildPythonPackage (finalAttrs: {
  pname = "bioutils";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "biocommons";
    repo = "bioutils";
    tag = finalAttrs.version;
    hash = "sha256-yrj68Z6F+owzcKvZjdQE+FQLjHHJSSbAkz/XRNbjzos=";
  };
  pyproject = true;

  # https://github.com/biocommons/bioutils/issues/111
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools_scm[toml] ~= 8.1"' '"setuptools_scm[toml]"'
  '';

  build-system = [
    setuptools
    setuptools-scm
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

  disabledTestPaths = [
    "tests/test_docs.py"
  ];

  pythonImportsCheck = [ "bioutils" ];

  meta = {
    changelog = "https://github.com/biocommons/bioutils/releases/tag/${finalAttrs.src.tag}";
    description = "Common utilities and lookup tables for bioinformatics";
    homepage = "https://biocommons.org/en/latest/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rub-br ];
  };
})
