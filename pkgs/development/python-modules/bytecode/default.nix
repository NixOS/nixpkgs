{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "bytecode";
  version = "0.14.1";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vstinner";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-vSuGjNTQw7prFxmVyiq7s8cnl+VGbRArC2sp7GVP0XA=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bytecode" ];

  meta = with lib; {
    homepage = "https://github.com/vstinner/bytecode";
    description = "Python module to generate and modify bytecode";
    license = licenses.mit;
    maintainers = with maintainers; [ raboof ];
  };
}
