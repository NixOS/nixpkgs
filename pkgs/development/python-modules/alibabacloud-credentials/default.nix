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
  version = "1.0.7";
  pyproject = true;

  src = fetchPypi {
    pname = "alibabacloud_credentials";
    inherit (finalAttrs) version;
    hash = "sha256-gEKCgLS8+VRh1B0UkKIjYLi2fRgpvx6zj3T6vMaT8bM=";
  };

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
    homepage = "https://pypi.org/project/alibabacloud-credentials/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
