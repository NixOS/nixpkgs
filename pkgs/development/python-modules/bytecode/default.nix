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
  version = "0.16.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vstinner";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Nj/GKZC+zZt1M4Qd7CMXQCLwTIu64aidasH4PwBLtzw=";
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
