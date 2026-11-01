{
  lib,
  alibabacloud-endpoint-util,
  alibabacloud-openapi-util,
  alibabacloud-tea-openapi,
  alibabacloud-tea-util,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-rds20140815";
  version = "16.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "alibabacloud_rds20140815";
    inherit (finalAttrs) version;
    hash = "sha256-yjtYg7UWFTSNEDOQlkcIMVGFXrJQqh3dOQT/8ARzKN8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    alibabacloud-endpoint-util
    alibabacloud-openapi-util
    alibabacloud-tea-openapi
    alibabacloud-tea-util
  ];

  pythonImportsCheck = [ "alibabacloud_rds20140815" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Alibaba Cloud rds (20140815) SDK Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-rds20140815/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
