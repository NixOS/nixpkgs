{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "bytecode";
  version = "0.14.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "vstinner";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-nGZ4qcms27lYr1dYvVe4ebd/jc5qIb1EDhSpSZmKKIo=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  checkInputs = [
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
