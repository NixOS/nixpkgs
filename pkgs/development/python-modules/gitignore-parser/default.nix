{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "gitignore-parser";
  version = "0.1.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mherrmann";
    repo = "gitignore_parser";
    tag = "v${version}";
    hash = "sha256-jd5C8whfdLuEC+ebDAAYso33o2H963P+8RWcm26koVM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "gitignore_parser" ];

  meta = with lib; {
    description = "Spec-compliant gitignore parser";
    homepage = "https://github.com/mherrmann/gitignore_parser";
    changelog = "https://github.com/mherrmann/gitignore_parser/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
