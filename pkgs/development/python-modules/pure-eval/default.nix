{ lib
, buildPythonPackage
, isPy3k
, fetchFromGitHub
, setuptools-scm
, toml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pure_eval";
  version = "0.2.1";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+Vucu16NFPtQ23AbBH/cQU+klxp6DMicSScbnKegLZI=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  buildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    toml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pure_eval" ];

  meta = with lib; {
    description = "Safely evaluate AST nodes without side effects";
    homepage = "https://github.com/alexmojaki/pure_eval";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
