{
  lib,
  alibabacloud-tea-util,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-openapi-util";
  version = "0.2.4";
  pyproject = true;

  src = fetchPypi {
    pname = "alibabacloud_openapi_util";
    inherit (finalAttrs) version;
    hash = "sha256-hwIrnct1k6YB96QMppgiesPMt3a1jLewa43H9RCZXDQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    alibabacloud-tea-util
    cryptography
  ];

  pythonImportsCheck = [ "alibabacloud_openapi_util" ];

  # Module has only tests in the untagged upstream repo
  doCheck = false;

  meta = {
    description = "Aliyun Tea OpenApi Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-openapi-util/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
