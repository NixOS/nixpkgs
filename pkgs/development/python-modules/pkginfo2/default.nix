{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pkginfo2";
  version = "30.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "pkginfo2";
    tag = "v${version}";
    hash = "sha256-E9EyaN3ncf/34vvvhRe0rwV28VrjqJo79YFgXq2lKWU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pkginfo2" ];

  disabledTests = [
    # AssertionError
    "test_ctor_w_path"
  ];

  meta = with lib; {
    description = "Query metadatdata from sdists, bdists or installed packages";
    homepage = "https://github.com/nexB/pkginfo2";
    changelog = "https://github.com/aboutcode-org/pkginfo2/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pkginfo2";
  };
}
