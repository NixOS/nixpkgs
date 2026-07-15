{
  lib,
  alibabacloud-endpoint-util,
  alibabacloud-openapi-util,
  alibabacloud-tea-openapi,
  alibabacloud-tea-util,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-ram20150501";
  version = "1.2.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "alibabacloud_ram20150501";
    inherit (finalAttrs) version;
    hash = "sha256-dzFVfjw5oPAVm59dEMksDeZZXCf0VT3EWeA8zZpMIqU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    alibabacloud-endpoint-util
    alibabacloud-openapi-util
    alibabacloud-tea-openapi
    alibabacloud-tea-util
  ];

  pythonImportsCheck = [ "alibabacloud_ram20150501" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Alibaba Cloud Resource Access Management (20150501) SDK Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-ram20150501/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
