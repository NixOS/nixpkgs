{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "bytecode";
  version = "0.16.1";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vstinner";
    repo = pname;
    tag = version;
    hash = "sha256-ckakH+H4h2Iwl4tkUpnVV23dkKP9Q7I86oygxfHkXU8=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bytecode" ];

  meta = with lib; {
    homepage = "https://github.com/vstinner/bytecode";
    description = "Python module to generate and modify bytecode";
    license = licenses.mit;
    maintainers = with maintainers; [ raboof ];
  };
}
