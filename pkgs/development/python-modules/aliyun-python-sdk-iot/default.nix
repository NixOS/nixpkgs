{ lib
, aliyun-python-sdk-core
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aliyun-python-sdk-iot";
  version = "8.41.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t/SIEW1JMTyeOhhxx6IhLsbQa0D3aqD2hqGk8+Ka0ns=";
  };

  propagatedBuildInputs = [
    aliyun-python-sdk-core
  ];

  # All components are stored in a mono repo
  doCheck = false;

  pythonImportsCheck = [
    "aliyunsdkiot"
  ];

  meta = with lib; {
    description = "IoT module of Aliyun Python SDK";
    homepage = "https://github.com/aliyun/aliyun-openapi-python-sdk";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
