{
  lib,
  alibabacloud-tea,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "alibabacloud-tea-util";
  version = "0.3.14";
  pyproject = true;

  src = fetchPypi {
    pname = "alibabacloud_tea_util";
    inherit version;
    hash = "sha256-cI58n2RkGjyeDlZjZdLyNnX418Kj4pcdlALO7eBAjNs=";
  };

  build-system = [ setuptools ];

  dependencies = [ alibabacloud-tea ];

  pythonImportsCheck = [ "alibabacloud_tea_util" ];

  # Module has only tests in the untagged upstream repo
  doCheck = false;

  meta = {
    description = "Aliyun Tea Util Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-tea-util/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
