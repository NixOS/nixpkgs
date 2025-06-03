{
  lib,
  aliyun-python-sdk-core,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aliyun-python-sdk-dbfs";
  version = "2.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Kj6DfnXZq5ilE+vnZrAoZEhPDoNrMIs5p2OcBc24qXM=";
  };

  propagatedBuildInputs = [ aliyun-python-sdk-core ];

  # All components are stored in a mono repo
  doCheck = false;

  pythonImportsCheck = [ "aliyunsdkdbfs" ];

  meta = with lib; {
    description = "DBFS module of Aliyun Python SDK";
    homepage = "https://github.com/aliyun/aliyun-openapi-python-sdk";
    changelog = "https://github.com/aliyun/aliyun-openapi-python-sdk/blob/master/aliyun-python-sdk-dbfs/ChangeLog.txt";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
