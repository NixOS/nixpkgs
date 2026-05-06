{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  markdown,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mdx-breakless-lists";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamb70";
    repo = "mdx-breakless-lists";
    tag = "v${version}";
    hash = "sha256-V0Bl1BCMXoQTeWC3WVzvfGY2RTirtCGqkGz8IGcuqRQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ markdown ];

  pythonImportsCheck = [ "mdx_breakless_lists" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "mdx_breakless_lists/tests.py" ];

  meta = {
    description = "Extension for Python-Markdown that allows lists without requiring a line break above them";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
