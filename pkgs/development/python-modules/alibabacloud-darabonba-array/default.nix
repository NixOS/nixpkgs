{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-darabonba-array";
  version = "0.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "alibabacloud_darabonba_array";
    inherit (finalAttrs) version;
    hash = "sha256-f5p8YyUY/08M67DU6CWkjBLnzwuQFuolBU3XNzLhVao=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "alibabacloud_darabonba_array" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Alibaba Cloud Darabonba Array SDK Library for Python";
    homepage = "https://github.com/aliyun/darabonba-array";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
