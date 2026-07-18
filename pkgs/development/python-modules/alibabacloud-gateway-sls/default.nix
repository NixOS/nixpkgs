{
  lib,
  alibabacloud-darabonba-array,
  alibabacloud-darabonba-encode-util,
  alibabacloud-darabonba-map,
  alibabacloud-darabonba-signature-util,
  alibabacloud-darabonba-string,
  alibabacloud-gateway-sls-util,
  alibabacloud-gateway-spi,
  alibabacloud-openapi-util,
  alibabacloud-tea-util,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-gateway-sls";
  version = "0.4.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "alibabacloud_gateway_sls";
    inherit (finalAttrs) version;
    hash = "sha256-EGaFojtJqy8Ggu4sPhYNqbUOpGbeUxtOklm8jAWD1h4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    alibabacloud-darabonba-array
    alibabacloud-darabonba-encode-util
    alibabacloud-darabonba-map
    alibabacloud-darabonba-signature-util
    alibabacloud-darabonba-string
    alibabacloud-gateway-sls-util
    alibabacloud-gateway-spi
    alibabacloud-openapi-util
    alibabacloud-tea-util
  ];

  pythonImportsCheck = [ "alibabacloud_gateway_sls" ];

  # Module has only tests in the untagged upstream repo
  doCheck = false;

  meta = {
    description = "Aliyun Gateway SLS Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-gateway-sls/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
