{
  lib,
  aliyun-python-sdk-core,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "aliyun-python-sdk-cdn";
  version = "3.8.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LMCNvjV85TvdSM0OXean4dPzAiV8apVdRLTvUISOKec=";
  };

  propagatedBuildInputs = [ aliyun-python-sdk-core ];

  # All components are stored in a mono repo
  doCheck = false;

  pythonImportsCheck = [ "aliyunsdkcdn" ];

  meta = {
    description = "CDN module of Aliyun Python SDK";
    homepage = "https://github.com/aliyun/aliyun-openapi-python-sdk";
    changelog = "https://github.com/aliyun/aliyun-openapi-python-sdk/blob/master/aliyun-python-sdk-cdn/ChangeLog.txt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
