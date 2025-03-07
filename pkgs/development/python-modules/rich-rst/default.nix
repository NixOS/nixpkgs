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
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wasi-master";
    repo = "rich-rst";
    rev = "refs/tags/v${version}";
    hash = "sha256-jbzGTEth5Qoc0ORFCS3sZMrGUpoQQOVsd+l3/zMWy20=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docutils
    rich
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rich_rst" ];

  meta = with lib; {
    description = "Beautiful reStructuredText renderer for rich";
    homepage = "https://github.com/wasi-master/rich-rst";
    license = licenses.mit;
    maintainers = with maintainers; [ joelkoen ];
  };
}
