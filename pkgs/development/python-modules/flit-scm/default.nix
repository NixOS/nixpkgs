{ lib
, buildPythonPackage
, fetchFromGitLab
, pythonOlder
, flit-core
, setuptools-scm
, tomli
}:

buildPythonPackage rec {
  pname = "flit-scm";
  version = "1.7.0";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "WillDaSilva";
    repo = "flit_scm";
    rev = "refs/tags/${version}";
    hash = "sha256-2nx9kWq/2TzauOW+c67g9a3JZ2dhBM4QzKyK/sqWOPo=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    flit-core
    setuptools-scm
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  propagatedBuildInputs = [
    flit-core
    setuptools-scm
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  pythonImportsCheck = [
    "flit_scm"
  ];


  doCheck = false; # no tests

  meta = with lib; {
    description = "A PEP 518 build backend that uses setuptools_scm to generate a version file from your version control system, then flit to build the package.";
    homepage = "https://gitlab.com/WillDaSilva/flit_scm";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
