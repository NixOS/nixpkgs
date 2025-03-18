{
  lib,
  buildPythonPackage,
  fetchPypi,
  ply,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "phply";
  version = "1.2.6";

  src = fetchPypi {
    pname = "phply";
    inherit version;
    sha256 = "sha256-Cyd3TShfUHo0RYBaBfj7KZj1bXCScPeLiSCLZbDYSRc=";
  };

  dependencies = [ ply ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "phply" ];

  meta = with lib; {
    description = "Lexer and parser for PHP source implemented using PLY";
    homepage = "https://github.com/viraptor/phply";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
  };
}
