{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  parameterized,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "moreorless";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thatch";
    repo = "moreorless";
    tag = "v${version}";
    hash = "sha256-VCvvPxDWriaeKeRaj/YbPLPfNL7fipGwCydr6K0HMjc=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ click ];

  nativeCheckInputs = [
    parameterized
    pytestCheckHook
  ];

  pythonImportsCheck = [ "moreorless" ];

  enabledTestPaths = [
    "moreorless/tests/click.py"
    "moreorless/tests/combined.py"
    "moreorless/tests/general.py"
    "moreorless/tests/patch.py"
  ];

  meta = {
    changelog = "https://github.com/thatch/moreorless/releases/tag/${src.tag}";
    description = "Wrapper to make difflib.unified_diff more fun to use";
    homepage = "https://github.com/thatch/moreorless/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
