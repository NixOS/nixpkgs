{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, future
, cppy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "atom";
  version = "0.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nucleic";
    repo = pname;
    rev = version;
    hash = "sha256-Xby3QopKw7teShMi80RMG8YdhOOvfQb5vwOuFEUTxHQ=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    cppy
  ];

  preCheck = ''
    rm -rf atom
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "atom.api"
  ];

  meta = with lib; {
    description = "Memory efficient Python objects";
    maintainers = [ maintainers.bhipple ];
    homepage = "https://github.com/nucleic/atom";
    license = licenses.bsd3;
  };
}
