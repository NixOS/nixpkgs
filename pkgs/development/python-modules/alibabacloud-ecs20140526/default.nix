{
  lib,
  alibabacloud-tea-openapi,
  buildPythonPackage,
  darabonba-core,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-ecs20140526";
  version = "7.9.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "alibabacloud_ecs20140526";
    inherit (finalAttrs) version;
    hash = "sha256-m1eaDj6VLGwJwfF3Dg6nN+YISHQuY+ij7uJ1KMFKvDU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    alibabacloud-tea-openapi
    darabonba-core
  ];

  pythonImportsCheck = [ "alibabacloud_ecs20140526" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Alibaba Cloud Elastic Compute Service (20140526) SDK Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-ecs20140526/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
