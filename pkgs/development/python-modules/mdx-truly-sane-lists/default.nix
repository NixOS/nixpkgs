{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  markdown,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mdx-truly-sane-lists";
  version = "1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "radude";
    repo = "mdx_truly_sane_lists";
    tag = version;
    hash = "sha256-hPnqF1UA4peW8hzeFiMlsBPfodC1qJXETGoq2yUm7d4=";
  };

  build-system = [ setuptools ];

  dependencies = [ markdown ];

  pythonImportsCheck = [ "mdx_truly_sane_lists" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "mdx_truly_sane_lists/tests.py" ];

  meta = {
    description = "Extension for Python-Markdown that makes lists truly sane";
    longDescription = ''
      Features custom indents for nested lists and fix for messy linebreaks and
      paragraphs between lists.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
