{
  lib,
  aliyun-python-sdk-core,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "aliyun-python-sdk-config";
  version = "2.2.14";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-drmk41/k/JJ6Zs6MrnMQa7xwpkO7MZEaSeyfm2QimKo=";
  };

  propagatedBuildInputs = [ aliyun-python-sdk-core ];

  # All components are stored in a mono repo
  doCheck = false;

  pythonImportsCheck = [ "aliyunsdkconfig" ];

  meta = {
    description = "Configuration module of Aliyun Python SDK";
    homepage = "https://github.com/aliyun/aliyun-openapi-python-sdk";
    changelog = "https://github.com/aliyun/aliyun-openapi-python-sdk/blob/master/aliyun-python-sdk-config/ChangeLog.txt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
