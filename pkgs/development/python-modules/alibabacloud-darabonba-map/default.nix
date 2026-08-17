{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-darabonba-map";
  version = "0.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "alibabacloud_darabonba_map";
    inherit (finalAttrs) version;
    hash = "sha256-rbFzhGWKGo9yQY8YONS2pf0lZr/TkqPvBtnbsKWVoj8=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "alibabacloud_darabonba_map" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Alibaba Cloud Darabonba Map SDK Library for Python";
    homepage = "https://github.com/aliyun/darabonba-map";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
