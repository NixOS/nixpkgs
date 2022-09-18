{ lib
, aliyun-python-sdk-core
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aliyun-python-sdk-cdn";
  version = "3.7.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7ZDhsu5XDE7hDVaG4RdEWcKfVrC2tPwLPdGB+uDXRpA=";
  };

  propagatedBuildInputs = [
    aliyun-python-sdk-core
  ];

  # All components are stored in a mono repo
  doCheck = false;

  pythonImportsCheck = [
    "aliyunsdkcdn"
  ];

  meta = with lib; {
    description = "CDN module of Aliyun Python SDK";
    homepage = "https://github.com/aliyun/aliyun-openapi-python-sdk";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
