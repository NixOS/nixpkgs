{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "bytecode";
  version = "0.19.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MatthieuDartiailh";
    repo = "bytecode";
    tag = version;
    hash = "sha256-RllKrP5oEmpSH8PTCct8t0uuLDnB57LOzkIELA79gTI=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bytecode" ];

  meta = {
    homepage = "https://github.com/vstinner/bytecode";
    description = "Python module to generate and modify bytecode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raboof ];
  };
}
