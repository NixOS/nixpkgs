{ lib
, aliyun-python-sdk-core
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aliyun-python-sdk-config";
  version = "2.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Me5z68cOfLt8PDHaZ1b/F/KG5mtYAW3LXmNd+0epha8=";
  };

  propagatedBuildInputs = [
    aliyun-python-sdk-core
  ];

  # All components are stored in a mono repo
  doCheck = false;

  pythonImportsCheck = [
    "aliyunsdkconfig"
  ];

  meta = with lib; {
    description = "Configuration module of Aliyun Python SDK";
    homepage = "https://github.com/aliyun/aliyun-openapi-python-sdk";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
