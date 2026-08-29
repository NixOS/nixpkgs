{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pylatexenc";
  version = "2.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "phfaist";
    repo = "pylatexenc";
    rev = "v${version}";
    hash = "sha256-Zv3Sjx0YpSCnoHHf3CSiGaFMS7FNgUUwvIxNX/k9tOg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pylatexenc" ];
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Simple LaTeX parser providing latex-to-unicode and unicode-to-latex conversion";
    homepage = "https://pylatexenc.readthedocs.io";
    downloadPage = "https://www.github.com/phfaist/pylatexenc/releases";
    changelog = "https://pylatexenc.readthedocs.io/en/latest/changes/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
