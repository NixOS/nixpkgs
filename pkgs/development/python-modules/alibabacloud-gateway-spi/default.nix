{
  lib,
  alibabacloud-credentials,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "alibabacloud-gateway-spi";
  version = "0.0.3";
  pyproject = true;

  src = fetchPypi {
    pname = "alibabacloud_gateway_spi";
    inherit version;
    hash = "sha256-ENHFOj/F+HkV+9a0mFuYM4p3bptEoCY/VmQ8UEgiO4s=";
  };

  build-system = [ setuptools ];

  dependencies = [ alibabacloud-credentials ];

  pythonImportsCheck = [ "alibabacloud_gateway_spi" ];

  # Module has only tests in the untagged upstream repo
  doCheck = false;

  meta = {
    description = "Aliyun Gateway SPI Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-gateway-spi/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
