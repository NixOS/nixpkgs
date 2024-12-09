{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lnkparse3";
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Matmaus";
    repo = "LnkParse3";
    rev = "refs/tags/v${version}";
    hash = "sha256-oyULNRjC0pcVUOeTjjW3g3mB7KySYcwAS+/KwQEIkK4=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyyaml ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "LnkParse3" ];

  meta = with lib; {
    description = "Windows Shortcut file (LNK) parser";
    homepage = "https://github.com/Matmaus/LnkParse3";
    changelog = "https://github.com/Matmaus/LnkParse3/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
