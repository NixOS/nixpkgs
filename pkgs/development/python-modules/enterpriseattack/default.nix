{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
  setuptools-scm,
  ujson,
}:

buildPythonPackage rec {
  pname = "enterpriseattack";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xakepnz";
    repo = "enterpriseattack";
    tag = "v${version}";
    hash = "sha256-OZ/nao2oiXzzWl/zQA5A3GpsRNobnHb4ubAsZvVITj0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    requests
    ujson
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "enterpriseattack" ];

  meta = with lib; {
    description = "Module to interact with the Mitre Att&ck Enterprise dataset";
    homepage = "https://github.com/xakepnz/enterpriseattack";
    changelog = "https://github.com/xakepnz/enterpriseattack/releases/tag/v.${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
