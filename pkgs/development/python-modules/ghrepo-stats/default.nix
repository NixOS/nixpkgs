{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, PyGithub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ghrepo-stats";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mrbean-bremen";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KFjqHrN0prcqu3wEPZpa7rLfuD0X/DN7BMo4zcHNmYo=";
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
