{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-darabonba-time";
  version = "0.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "alibabacloud_darabonba_time";
    inherit (finalAttrs) version;
    hash = "sha256-CtnHsGllcNGj9AEGzHd391X9krqg0dyrW333jd5bki0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "alibabacloud_darabonba_time" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Alibaba Cloud Darabonba Time SDK Library for Python";
    homepage = "https://github.com/aliyun/darabonba-time";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
