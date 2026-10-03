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
  ...
}:
buildPythonPackage (finalAttrs: {
  pname = "hgvs";
  version = "1.5.7";
  src = fetchFromGitHub {
    owner = "biocommons";
    repo = "hgvs";
    tag = finalAttrs.version;
    hash = "sha256-vW/gsLDq2wbvqa3535WLPy/qbSEIhXS/3tBU2CHy4P8=";
  };

  pyproject = true;

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
