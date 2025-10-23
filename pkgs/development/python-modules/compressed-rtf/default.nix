{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage {
  pname = "compressed-rtf";
  version = "1.0.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "delimitry";
    repo = "compressed_rtf";
    # https://github.com/delimitry/compressed_rtf/issues/15
    rev = "581400c1b4c69ab0d944cfb5ca82c32059bbcc96";
    hash = "sha256-ivvND+cOCAmRyO8yL0+WhFY/2OkrJ+E/o4xWWd7ivHA=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "compressed_rtf" ];

  enabledTestPaths = [ "tests/tests.py" ];

  meta = with lib; {
    description = "Compressed Rich Text Format (RTF) compression and decompression";
    homepage = "https://github.com/delimitry/compressed_rtf";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
