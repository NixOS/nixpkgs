{
  lib,
  buildPythonPackage,
  exceptiongroup,
  fetchPypi,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "generic";
  version = "1.1.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3QcFbbWgCJcL37MwiK1Sv7LG6N60zsw93CupD4Xzp/w=";
  };

  build-system = [ poetry-core ];

  dependencies = [ exceptiongroup ];

  pythonImportsCheck = [ "generic" ];

  meta = with lib; {
    description = "Generic programming (Multiple dispatch) library for Python";
    homepage = "https://github.com/gaphor/generic";
    changelog = "https://github.com/gaphor/generic/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
