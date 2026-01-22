{
  lib,
  buildPythonPackage,
  crc16,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyoppleio";
  version = "1.0.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S1w3pPqhX903kkXUq9ALz0+zRvNGOimLughRRVKjV8E=";
  };

  build-system = [ setuptools ];

  dependencies = [ crc16 ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyoppleio" ];

  meta = {
    description = "Library for interacting with OPPLE lights";
    homepage = "https://github.com/jedmeng/python-oppleio";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "oppleio";
  };
}
