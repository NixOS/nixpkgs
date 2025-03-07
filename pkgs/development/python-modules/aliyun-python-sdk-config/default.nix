{
  lib,
  aliyun-python-sdk-core,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aliyun-python-sdk-config";
  version = "2.2.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-w4YJe3Bngg4A2KVlpIqf80FHhscLMMMk0AVkr/NfbPM=";
  };

  propagatedBuildInputs = [ aliyun-python-sdk-core ];

  # All components are stored in a mono repo
  doCheck = false;

  pythonImportsCheck = [ "aliyunsdkconfig" ];

  meta = with lib; {
    description = "Configuration module of Aliyun Python SDK";
    homepage = "https://github.com/aliyun/aliyun-openapi-python-sdk";
    changelog = "https://github.com/aliyun/aliyun-openapi-python-sdk/blob/master/aliyun-python-sdk-config/ChangeLog.txt";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
