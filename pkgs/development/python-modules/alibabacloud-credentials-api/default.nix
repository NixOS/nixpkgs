{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "alibabacloud-credentials-api";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jDQAONkE8CGNchSo9AiMMZEr/PJ5ryy8fZvkiXqX3S8=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "alibabacloud_credentials_api" ];

  # Module has only tests in the untagged upstream repo
  doCheck = false;

  meta = {
    description = "Aliyun Credentials API Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-credentials-api/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
