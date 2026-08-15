{
  lib,
  alibabacloud-tea,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "alibabacloud-tea-xml";
  version = "0.0.3";
  pyproject = true;

  src = fetchPypi {
    pname = "alibabacloud_tea_xml";
    inherit (finalAttrs) version;
    hash = "sha256-l5y1H630Ped/QcafxpwSUpcokZ+ElyPrDNJOt7BIqQw=";
  };

  build-system = [ setuptools ];

  dependencies = [ alibabacloud-tea ];

  pythonImportsCheck = [ "alibabacloud_tea_xml" ];

  # Module has only tests in the untagged upstream repo
  doCheck = false;

  meta = {
    description = "Aliyun Tea XML Library for Python";
    homepage = "https://pypi.org/project/alibabacloud-tea-xml/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
