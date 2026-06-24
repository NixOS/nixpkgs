{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  docutils,
  rich,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rich-rst";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wasi-master";
    repo = "rich-rst";
    tag = "v${version}";
    hash = "sha256-7nniBu9UnXA0pogv0TDkANTeOcsVYbyDxEr6/r7MxcY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

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
