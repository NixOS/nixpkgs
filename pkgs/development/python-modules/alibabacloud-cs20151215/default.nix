{
  lib,
  alibabacloud-gateway-pop,
  alibabacloud-tea-openapi,
  buildPythonPackage,
  darabonba-core,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-cs20151215";
  version = "7.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "alibabacloud_cs20151215";
    inherit (finalAttrs) version;
    hash = "sha256-yNwy863Z2FZFsEznoR0doIDY9wnxzRuhMx5K/inhrU8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    alibabacloud-gateway-pop
    alibabacloud-tea-openapi
    darabonba-core
  ];

  pythonImportsCheck = [ "alibabacloud_cs20151215" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Alibaba Cloud CS (20151215) SDK Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-cs20151215/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
