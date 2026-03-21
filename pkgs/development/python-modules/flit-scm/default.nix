{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  flit-core,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "flit-scm";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "WillDaSilva";
    repo = "flit_scm";
    tag = version;
    hash = "sha256-2nx9kWq/2TzauOW+c67g9a3JZ2dhBM4QzKyK/sqWOPo=";
  };

  nativeBuildInputs = [
    flit-core
    setuptools-scm
  ];

  propagatedBuildInputs = [
    flit-core
    setuptools-scm
  ];

  pythonImportsCheck = [ "flit_scm" ];

  doCheck = false; # no tests

  meta = {
    description = "PEP 518 build backend that uses setuptools_scm to generate a version file from your version control system, then flit to build the package";
    homepage = "https://gitlab.com/WillDaSilva/flit_scm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
