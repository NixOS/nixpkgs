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
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wasi-master";
    repo = "rich-rst";
    rev = "refs/tags/v${version}";
    hash = "sha256-A3SPbu1N5X55c32S8z8UPpmniJT+mdqfb1+zQEJMA5k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docutils
    rich
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rich_rst" ];

  meta = with lib; {
    description = "A beautiful reStructuredText renderer for rich";
    homepage = "https://github.com/wasi-master/rich-rst";
    license = licenses.mit;
    maintainers = with maintainers; [ joelkoen ];
  };
}
