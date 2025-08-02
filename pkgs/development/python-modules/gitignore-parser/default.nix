{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "gitignore-parser";
  version = "0.1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mherrmann";
    repo = "gitignore_parser";
    tag = "v${version}";
    hash = "sha256-s1t7WTrtxeeL4we+Y8I6XK8vKzmDVftmtXhRS/XeSAM=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "gitignore_parser" ];

  meta = with lib; {
    description = "Spec-compliant gitignore parser";
    homepage = "https://github.com/mherrmann/gitignore_parser";
    changelog = "https://github.com/mherrmann/gitignore_parser/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
