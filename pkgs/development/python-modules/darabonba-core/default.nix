{
  lib,
  aiohttp,
  alibabacloud-tea,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
  websocket-client,
}:

buildPythonPackage (finalAttrs: {
  pname = "darabonba-core";
  version = "1.0.10";
  pyproject = true;

  src = fetchPypi {
    pname = "darabonba_core";
    inherit (finalAttrs) version;
    hash = "sha256-zvERCIF+NA4EvPopnVAspPf8kiF1pFrRIslYHcgEPFQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    alibabacloud-tea
    requests
    websocket-client
  ];

  pythonImportsCheck = [ "Tea" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "The darabonba module of alibabaCloud Python SDK";
    homepage = "https://github.com/aliyun/tea-python";
    changelog = "https://github.com/aliyun/tea-python/blob/master/ChangeLog.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
