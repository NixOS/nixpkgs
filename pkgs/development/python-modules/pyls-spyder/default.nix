{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-lsp-server,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyls-spyder";
  version = "0.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "spyder-ide";
    repo = "pyls-spyder";
    rev = "v${version}";
    hash = "sha256-c8J20xL7z/knRUkZvBpzybRwsdorm2p0YqQBo6JeUoU=";
  };

  propagatedBuildInputs = [ python-lsp-server ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyls_spyder" ];

  meta = {
    description = "Spyder extensions for the python-language-server";
    homepage = "https://github.com/spyder-ide/pyls-spyder";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
