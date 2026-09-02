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
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "serge-sans-paille";
    repo = "beniget";
    tag = version;
    hash = "sha256-abxBLrz4JhZX084fd2wZEhP7w5bPBxvNXudYUaqS1Yo=";
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
