{
  lib,
  alibabacloud-gateway-oss,
  alibabacloud-gateway-spi,
  alibabacloud-openapi-util,
  alibabacloud-tea-openapi,
  alibabacloud-tea-util,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-oss20190517";
  version = "1.0.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "alibabacloud_oss20190517";
    inherit (finalAttrs) version;
    hash = "sha256-fND7Fq9hPOs40uDlKaofWAOMfPWetnyMh3WuROpxeFI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    alibabacloud-gateway-oss
    alibabacloud-gateway-spi
    alibabacloud-openapi-util
    alibabacloud-tea-openapi
    alibabacloud-tea-util
  ];

  pythonImportsCheck = [ "alibabacloud_oss20190517" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Alibaba Cloud Object Storage Service (20190517) SDK Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-oss20190517/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
