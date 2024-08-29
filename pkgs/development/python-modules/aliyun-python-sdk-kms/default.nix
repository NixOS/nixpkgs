{
  lib,
  aliyun-python-sdk-core,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aliyun-python-sdk-kms";
  version = "2.16.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DVuxZcB7apcpOXU6EoUHOT9IAReS7g7E9ZtgIeq9l1I=";
  };

  build-system = [ setuptools ];

  dependencies = [ aliyun-python-sdk-core ];

  # All components are stored in a mono repo
  doCheck = false;

  pythonImportsCheck = [ "aliyunsdkkms" ];

  meta = with lib; {
    description = "KMS module of Aliyun Python SDK";
    homepage = "https://github.com/aliyun/aliyun-openapi-python-sdk";
    changelog = "https://github.com/aliyun/aliyun-openapi-python-sdk/blob/master/aliyun-python-sdk-kms/ChangeLog.txt";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
