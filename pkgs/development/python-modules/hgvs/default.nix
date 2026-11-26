{
  fetchFromGitHub,
  bioutils,
  biocommons-seqrepo,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  attrs,
  requests,
  ipython,
  configparser,
  importlib-resources,
  parsley,
  psycopg2,
  lib,
}:
buildPythonPackage (finalAttrs: {
  pname = "hgvs";
  version = "2.0.0a0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biocommons";
    repo = "hgvs";
    tag = finalAttrs.version;
    hash = "sha256-WM/023sNzcn+mwaL3POdfSJ/pkscXNDwZ9NyU0doTd0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    attrs
    requests
    bioutils
    biocommons-seqrepo
    ipython
    configparser
    importlib-resources
    parsley
    psycopg2
  ];

  pythonImportsCheck = [ "hgvs" ];

  meta = {
    changelog = "https://github.com/biocommons/hgvs/releases/tag/${finalAttrs.src.tag}";
    description = "Python library to parse, format, validate, normalize, and map sequence variants according to HGVS Nomenclature";
    homepage = "https://hgvs-nomenclature.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rub-br ];
  };
})
