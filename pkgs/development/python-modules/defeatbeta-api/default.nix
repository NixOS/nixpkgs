{
  lib,
  buildPythonPackage,
  duckdb,
  fetchFromGitHub,
  fsspec,
  h2,
  httpx,
  ipython,
  matplotlib,
  numpy,
  openai,
  openpyxl,
  pandas,
  psutil,
  pyfiglet,
  pysbd,
  pysocks,
  requests,
  rich,
  setuptools,
  socksio,
  tabulate,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "defeatbeta-api";
  version = "0.0.63";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "defeat-beta";
    repo = "defeatbeta-api";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-/I0q1+ndHtAjrr3LfUgUG3fPnJC0NsVmdFhN1nfxCRk=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "duckdb"
    "ipython"
  ];

  dependencies = [
    duckdb
    fsspec
    h2
    httpx
    ipython
    matplotlib
    numpy
    openai
    openpyxl
    pandas
    psutil
    pyfiglet
    pysbd
    pysocks
    requests
    rich
    socksio
    tabulate
    urllib3
  ];

  # The test suite queries the upstream market data service.
  doCheck = false;

  pythonImportsCheck = [ "defeatbeta_api" ];

  meta = {
    description = "Open source alternative to Yahoo Finance's market data APIs";
    homepage = "https://github.com/defeat-beta/defeatbeta-api";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
})
