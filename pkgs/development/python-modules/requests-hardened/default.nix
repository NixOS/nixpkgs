{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  poetry-core,
  requests,

  pproxy,
  pytest-socket,
  pysocks,
  trustme,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "requests-hardened";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "saleor";
    repo = "requests-hardened";
    tag = "v${version}";
    hash = "sha256-tvSS3z1fhQdcxvsj5vK//mr5xYeIrLl+6/gtnWsiETk=";
  };

  build-system = [ poetry-core ];
  dependencies = [ requests ];

  nativeCheckInputs = [
    pproxy
    pytest-socket
    pysocks
    trustme
    pytestCheckHook
  ];

  pythonImportsCheck = [ "requests_hardened" ];

  meta = {
    description = "Library that adds hardened behavior to python requests";
    homepage = "https://github.com/saleor/requests-hardened";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ryand56 ];
  };
}
