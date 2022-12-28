{ lib
, buildPythonPackage
, fetchFromGitLab
, pythonOlder
, git
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
    rev = version;
    sha256 = "sha256-K5sH+oHgX/ftvhkY+vIg6wUokAP96YxrTWds3tnEtyg=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ flit-core setuptools-scm tomli git ];
  propagatedBuildInputs = [ flit-core setuptools-scm ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  meta = with lib; {
    description = "A PEP 518 build backend that uses setuptools_scm to generate a version file from your version control system, then flit to build the package.";
    homepage = "https://gitlab.com/WillDaSilva/flit_scm";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
