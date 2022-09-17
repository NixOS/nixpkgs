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
  version = "2.13.36";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IL1UmE+jFtpwDH81WlGrC4FmkOKg/O+3te8BP+0NqSg=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
