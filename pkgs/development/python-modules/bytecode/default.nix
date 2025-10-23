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
  version = "0.17.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vstinner";
    repo = "bytecode";
    tag = version;
    hash = "sha256-AocS5Z4WkHTR+nO5/4B7oV/fb/ASG0aGrG/722Ioup0=";
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
