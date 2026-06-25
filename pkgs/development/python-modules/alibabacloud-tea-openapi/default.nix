{
  lib,
  alibabacloud-credentials,
  alibabacloud-gateway-spi,
  alibabacloud-tea-util,
  buildPythonPackage,
  cryptography,
  darabonba-core,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-tea-openapi";
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    pname = "alibabacloud_tea_openapi";
    inherit (finalAttrs) version;
    hash = "sha256-Co15N0ymkkaUcjVaEllpyKIsxfsIMox1wmZjzPXIsWg=";
  };

  pythonRelaxDeps = [ "cryptography" ];

  build-system = [ setuptools ];

  dependencies = [
    alibabacloud-credentials
    alibabacloud-gateway-spi
    alibabacloud-tea-util
    cryptography
    darabonba-core
  ];

  pythonImportsCheck = [ "Tea" ];

  # Module has only tests in the untagged upstream repo
  doCheck = false;

  meta = {
    description = "Aliyun Tea OpenAPI Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-tea-openapi/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
