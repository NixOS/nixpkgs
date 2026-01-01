{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
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

  build-system = [ setuptools ];

  dependencies = [ ply ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "phply" ];

<<<<<<< HEAD
  meta = {
    description = "Lexer and parser for PHP source implemented using PLY";
    homepage = "https://github.com/viraptor/phply";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ erictapen ];
=======
  meta = with lib; {
    description = "Lexer and parser for PHP source implemented using PLY";
    homepage = "https://github.com/viraptor/phply";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
