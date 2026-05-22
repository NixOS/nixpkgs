{
  lib,
  aiofiles,
  alibabacloud-credentials-api,
  alibabacloud-tea,
  apscheduler,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-credentials";
  version = "1.0.8";
  pyproject = true;

  src = fetchPypi {
    pname = "alibabacloud_credentials";
    inherit (finalAttrs) version;
    hash = "sha256-Nkwiq+8tJAslnOrfHOaAABfxmjNnKVU5VpKKHt0S52k=";
  };

  pythonRelaxDeps = [ "aiofiles" ];

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    alibabacloud-credentials-api
    alibabacloud-tea
    apscheduler
  ];

  pythonImportsCheck = [ "alibabacloud_credentials" ];

  # Module has only tests in the untagged upstream repo
  doCheck = false;

  meta = {
    description = "Aliyun Credentials Library for Python";
    homepage = "https://github.com/aliyun/credentials-python";
    changelog = "https://github.com/aliyun/credentials-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
