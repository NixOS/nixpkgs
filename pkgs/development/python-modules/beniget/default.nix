{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  gast,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "beniget";
  version = "0.4.2.post1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "beniget";
    tag = version;
    hash = "sha256-rNMgCEkI6p9KtLSz/2jVJ9rPeJzxv5rT+Pu6OHM8z70=";
  };

  build-system = [ setuptools ];

  dependencies = [ gast ];

  pythonImportsCheck = [ "beniget" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Extract semantic information about static Python code";
    homepage = "https://github.com/serge-sans-paille/beniget";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
