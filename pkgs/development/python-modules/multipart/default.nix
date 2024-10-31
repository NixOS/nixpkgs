{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "multipart";
  version = "0.2.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+piDjUDJZ7sZWJYmoPuKXEDEId2i/r4bA1H89ibiRlE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multipart" ];

  meta = {
    description = "Parser for multipart/form-data";
    homepage = "https://github.com/defnull/multipart";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
