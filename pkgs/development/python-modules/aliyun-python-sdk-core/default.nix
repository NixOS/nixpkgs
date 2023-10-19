{ lib
, buildPythonPackage
, cryptography
, fetchPypi
, jmespath
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "aliyun-python-sdk-core";
  version = "2.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yAaBWkj/24lMxbzhW4JZuaMBLMDNoBvi89+7hE8/TyE=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    cryptography
    jmespath
  ];

  # All components are stored in a mono repo
  doCheck = false;

  pythonRelaxDeps = true;

  pythonImportsCheck = [
    "aliyunsdkcore"
  ];

  meta = with lib; {
    description = "Core module of Aliyun Python SDK";
    homepage = "https://github.com/aliyun/aliyun-openapi-python-sdk";
    changelog = "https://github.com/aliyun/aliyun-openapi-python-sdk/blob/master/aliyun-python-sdk-core/ChangeLog.txt";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
