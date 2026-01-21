{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  docutils,
  rich,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rich-rst";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wasi-master";
    repo = "rich-rst";
    tag = "v${version}";
    hash = "sha256-NL5Y3m8KcAiZIH6IvuPp75Tbxh/X9Ob5qUWtYfuq8Bc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docutils
    rich
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rich_rst" ];

  meta = {
    description = "Beautiful reStructuredText renderer for rich";
    homepage = "https://github.com/wasi-master/rich-rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
