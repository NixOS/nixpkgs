{
  lib,
  aliyun-python-sdk-core,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "aliyun-python-sdk-sts";
  version = "3.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Iv7bi60T+WbnEaH0Zi7te52zNEG8BapLD5GKoB4JuWc=";
  };

  propagatedBuildInputs = [ aliyun-python-sdk-core ];

  # All components are stored in a mono repo
  doCheck = false;

  pythonImportsCheck = [ "aliyunsdksts" ];

  meta = {
    description = "STS module of Aliyun Python SDK";
    homepage = "https://github.com/aliyun/aliyun-openapi-python-sdk";
    changelog = "https://github.com/aliyun/aliyun-openapi-python-sdk/blob/master/aliyun-python-sdk-sts/ChangeLog.txt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
