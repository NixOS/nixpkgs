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
  version = "1.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Matmaus";
    repo = "LnkParse3";
    tag = "v${version}";
    hash = "sha256-ebaKVl7GFoJiyQR7x4AN9Md8dtuYUchaN8ORbUrj5DY=";
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
