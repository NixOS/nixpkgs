{
  lib,
  aliyun-python-sdk-core,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aliyun-python-sdk-alimt";
  version = "3.2.0";
  format = "pyproject";

  # Upstream doesn't tag releases on Github
  # https://github.com/aliyun/aliyun-openapi-python-sdk/issues/551
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oz8PNY/j6xE7pY91F8O5ed2j02q8tFl1A/u9Q5fYbuA=";
  };

  build-system = [ setuptools ];

  dependencies = [ aliyun-python-sdk-core ];

  # All components are stored in a mono repo
  doCheck = false;

  pythonImportsCheck = [ "aliyunsdkalimt" ];

  meta = {
    description = "ALIMT module of Aliyun Python SDK";
    homepage = "https://github.com/aliyun/aliyun-openapi-python-sdk";
    changelog = "https://github.com/aliyun/aliyun-openapi-python-sdk/blob/master/aliyun-python-sdk-sts/ChangeLog.txt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
