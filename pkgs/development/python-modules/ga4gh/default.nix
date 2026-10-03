{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  setuptools,
  pydantic,
  bioutils,
  requests,
  canonicaljson,
  psycopg2-binary,
  dill,
  pysam,
  enableExtra ? true,
  click,
  biocommons-seqrepo,
  hgvs,
  pyyaml,
  lib,
  libpq,
  ...
}:
buildPythonPackage (finalAttrs: {
  pname = "ga4gh.vrs";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "ga4gh";
    repo = "vrs-python";
    tag = finalAttrs.version;
    hash = "sha256-6ULUSnrJmIo6ne4cCNAgZDKcGSsffUhKXZ0/5RjbSAA=";
  };

  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    libpq
  ];

  dependencies = [
    pydantic
    bioutils
    requests
    canonicaljson
  ]
  ++ lib.optionals enableExtra [
    psycopg2-binary
    dill
    pysam
    click
    biocommons-seqrepo
    hgvs
    pyyaml
  ];

  pythonCheckImports = [ "ga4gh.vrs" ];

  meta = {
    changelog = "https://github.com/ga4gh/vrs-python/releases/tag/${finalAttrs.src.tag}";
    description = "GA4GH Variation Representation Python Implementation";
    homepage = "https://github.com/ga4gh/vrs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rub-br ];
  };
})
