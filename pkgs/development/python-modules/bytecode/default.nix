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
  version = "0.16.2";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vstinner";
    repo = "bytecode";
    tag = version;
    hash = "sha256-74qEwAYHXV4HakJQ05A9K7LuO0xP28Hub6no09KO4r4=";
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
