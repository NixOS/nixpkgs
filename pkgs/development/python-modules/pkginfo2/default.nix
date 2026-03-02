{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pkginfo2";
  version = "30.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "pkginfo2";
    tag = "v${version}";
    hash = "sha256-M6fJbW1XCe+LKyjIupKnLmVkH582r1+AH44r9JA0Sxg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pkginfo2" ];

  disabledTests = [
    # AssertionError
    "test_ctor_w_path"
  ];

  meta = {
    description = "Query metadatdata from sdists, bdists or installed packages";
    homepage = "https://github.com/nexB/pkginfo2";
    changelog = "https://github.com/aboutcode-org/pkginfo2/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pkginfo2";
  };
}
