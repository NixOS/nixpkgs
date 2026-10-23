{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools_80,
  ply,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "phply";
  version = "1.2.6";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Cyd3TShfUHo0RYBaBfj7KZj1bXCScPeLiSCLZbDYSRc=";
  };

  build-system = [ setuptools_80 ];

  dependencies = [ ply ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "phply" ];

  meta = {
    description = "Lexer and parser for PHP source implemented using PLY";
    homepage = "https://github.com/viraptor/phply";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
