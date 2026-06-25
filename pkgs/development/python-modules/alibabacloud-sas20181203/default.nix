{
  lib,
  alibabacloud-tea-openapi,
  buildPythonPackage,
  darabonba-core,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-sas20181203";
  version = "9.3.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "alibabacloud_sas20181203";
    inherit (finalAttrs) version;
    hash = "sha256-Y1xDWiGmjuDkcgF6c031fe5xBO4tA8xUH9DIXBN2oRw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    alibabacloud-tea-openapi
    darabonba-core
  ];

  pythonImportsCheck = [ "alibabacloud_sas20181203" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Alibaba Cloud Threat Detection (20181203) SDK Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-sas20181203/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
