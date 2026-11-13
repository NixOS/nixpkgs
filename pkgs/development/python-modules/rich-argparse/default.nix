{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  rich,
}:

buildPythonPackage rec {
  pname = "rich-argparse";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hamdanal";
    repo = "rich-argparse";
    tag = "v${version}";
    hash = "sha256-ze9wJn+Cxz/NhbG8xKwHZHaDqMdU142/vJjml3Y9508=";
  };

  build-system = [ hatchling ];

  dependencies = [ rich ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # coloring mismatch in fixture
    "test_subparsers_usage"
    # solid vs dash line mismatch
    "test_rich_renderables"
  ];

  pythonImportsCheck = [ "rich_argparse" ];

  meta = {
    description = "Format argparse help output using rich";
    homepage = "https://github.com/hamdanal/rich-argparse";
    changelog = "https://github.com/hamdanal/rich-argparse/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ graham33 ];
  };
}
