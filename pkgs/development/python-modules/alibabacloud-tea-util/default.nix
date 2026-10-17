{
  lib,
  alibabacloud-tea,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-tea-util";
  version = "0.3.15";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "alibabacloud_tea_util";
    inherit (finalAttrs) version;
    hash = "sha256-efeOWW9r4D+5Vl40rEVCDzcw5SiIN2zJcTvQdDKkxsw=";
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
})
