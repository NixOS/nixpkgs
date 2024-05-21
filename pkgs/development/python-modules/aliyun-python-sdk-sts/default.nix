{ lib
, aliyun-python-sdk-core
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aliyun-python-sdk-sts";
  version = "3.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GLzieAX0j/aEKeKj37PtBQJy3c2zWgy1no7/lXiYSU0=";
  };

  propagatedBuildInputs = [
    aliyun-python-sdk-core
  ];

  # All components are stored in a mono repo
  doCheck = false;

  pythonImportsCheck = [
    "aliyunsdksts"
  ];

  meta = with lib; {
    description = "STS module of Aliyun Python SDK";
    homepage = "https://github.com/aliyun/aliyun-openapi-python-sdk";
    changelog = "https://github.com/aliyun/aliyun-openapi-python-sdk/blob/master/aliyun-python-sdk-sts/ChangeLog.txt";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
