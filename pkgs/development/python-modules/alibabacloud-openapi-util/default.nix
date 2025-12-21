{
  lib,
  alibabacloud-tea-util,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "alibabacloud-openapi-util";
  version = "0.2.2";
  pyproject = true;

  src = fetchPypi {
    pname = "alibabacloud_openapi_util";
    inherit version;
    hash = "sha256-67w5BvVUy0v49RPkPooz6Laj1KDvE2F6DhTD3ajvUqg=";
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
}
