{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-credentials-api";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "alibabacloud_credentials_api";
    inherit (finalAttrs) version;
    hash = "sha256-jqBmimVY9pVrjSCy5WHRmoDqKcIs9WowBNQ0skqYGzY=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "alibabacloud_credentials_api" ];

  # Module has only tests in the untagged upstream repo
  doCheck = false;

  meta = {
    description = "Aliyun Credentials API Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-credentials-api/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
