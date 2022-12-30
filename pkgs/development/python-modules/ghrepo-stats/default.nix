{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, PyGithub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ghrepo-stats";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mrbean-bremen";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-rTW6wADpkP9GglNmQNVecHfA2yJZuzYhJfsLfucbcgY=";
  };

  propagatedBuildInputs = [
    matplotlib
    PyGithub
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ghrepo_stats"
  ];

  meta = with lib; {
    description = "Python module and CLI tool for GitHub repo statistics";
    homepage = "https://github.com/mrbean-bremen/ghrepo-stats";
    changelog = "https://github.com/mrbean-bremen/ghrepo-stats/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
