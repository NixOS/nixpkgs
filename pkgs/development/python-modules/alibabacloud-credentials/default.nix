{
  lib,
  aiofiles,
  alibabacloud-credentials-api,
  alibabacloud-tea,
  apscheduler,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "alibabacloud-credentials";
  version = "1.0.4";
  pyproject = true;

  src = fetchPypi {
    pname = "alibabacloud_credentials";
    inherit version;
    hash = "sha256-K3GrMHRSZ6vVJNZPvgY/fgJknaKrbarx7sBXM7f5yPE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    alibabacloud-credentials-api
    alibabacloud-tea
    apscheduler
  ];

  pythonImportsCheck = [ "alibabacloud_credentials" ];

  # Module has only tests in the untagged upstream repo
  doCheck = false;

  meta = {
    description = "Aliyun Credentials Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-credentials/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
