{
  lib,
  aliyun-python-sdk-core,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "aliyun-python-sdk-iot";
  version = "8.59.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v0jTMKtYrbEBVjHQokpWSlcJBALZFsuoYHq8wCP8w1E=";
  };

  propagatedBuildInputs = [ aliyun-python-sdk-core ];

  # All components are stored in a mono repo
  doCheck = false;

  pythonImportsCheck = [ "aliyunsdkiot" ];

  meta = {
    description = "IoT module of Aliyun Python SDK";
    homepage = "https://github.com/aliyun/aliyun-openapi-python-sdk";
    changelog = "https://github.com/aliyun/aliyun-openapi-python-sdk/blob/master/aliyun-python-sdk-iot/ChangeLog.txt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
