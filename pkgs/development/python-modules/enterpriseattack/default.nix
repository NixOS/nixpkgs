{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
  setuptools-scm,
  ujson,
}:

buildPythonPackage (finalAttrs: {
  pname = "enterpriseattack";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xakepnz";
    repo = "enterpriseattack";
    tag = "v${finalAttrs.version}";
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

  meta = {
    description = "Module to interact with the Mitre Att&ck Enterprise dataset";
    homepage = "https://github.com/xakepnz/enterpriseattack";
    changelog = "https://github.com/xakepnz/enterpriseattack/releases/tag/v.${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
