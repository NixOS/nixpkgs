{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  astunparse,
  setuptools,
}:
buildPythonPackage rec {
  pname = "import-expression";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ioistired";
    repo = "import-expression-parser";
    rev = "refs/tags/v${version}";
    hash = "sha256-mll2NePB7fthzltLOk6D9BgaDpH6GaW4psqcGun/0qM=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ioistired/import-expression-parser/commit/3daf968c3163b64685aa529740e132f0df5ab262.patch";
      hash = "sha256-2Ubv3onor2D26udZbDDMb3iNLopEIRnIcO/X6WUVmJU=";
    })
  ];

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [ astunparse ];
  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [
    "import_expression"
    "import_expression._codec"
  ];

  meta = {
    description = "Transpiles a superset of python to allow easy inline imports";
    homepage = "https://github.com/ioistired/import-expression-parser";
    license = with lib.licenses; [
      mit
      psfl
    ];
    mainProgram = "import-expression";
    maintainers = with lib.maintainers; [ lychee ];
  };
}
