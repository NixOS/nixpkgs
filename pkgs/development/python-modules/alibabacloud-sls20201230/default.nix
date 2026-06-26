{
  lib,
  alibabacloud-gateway-sls,
  alibabacloud-tea-openapi,
  buildPythonPackage,
  darabonba-core,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-sls20201230";
  version = "5.14.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "alibabacloud_sls20201230";
    inherit (finalAttrs) version;
    hash = "sha256-tySehsqxNdVfTHan9603srbIuwOQDx6FLAB6S3Cc1YQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    alibabacloud-gateway-sls
    alibabacloud-tea-openapi
    darabonba-core
  ];

  pythonImportsCheck = [ "alibabacloud_sls20201230" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Alibaba Cloud Log Service (20201230) SDK Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-sls20201230/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
