{
  lib,
  alibabacloud-tea-openapi,
  buildPythonPackage,
  darabonba-core,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-vpc20160428";
  version = "7.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "alibabacloud_vpc20160428";
    inherit (finalAttrs) version;
    hash = "sha256-sXSZjBCeDZ/JwfPc1C1LP7AgpDUlfXAXcl0lZlTzyKc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    alibabacloud-tea-openapi
    darabonba-core
  ];

  pythonImportsCheck = [ "alibabacloud_vpc20160428" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Alibaba Cloud Virtual Private Cloud (20160428) SDK Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-vpc20160428/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
