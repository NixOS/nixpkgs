{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyhumps";
  version = "3.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nficano";
    repo = "humps";
    rev = "v${version}";
    hash = "sha256-ElL/LY2V2Z3efdV5FnDy9dSoBltULrzxsjaOx+7W9Oo=";
  };

  nativeBuildInputs = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "humps" ];

  meta = {
    description = "Module to convert strings (and dictionary keys) between snake case, camel case and pascal case";
    homepage = "https://github.com/nficano/humps";
    license = with lib.licenses; [ unlicense ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
