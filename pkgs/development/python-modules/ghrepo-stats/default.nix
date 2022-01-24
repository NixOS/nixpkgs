{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, PyGithub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ghrepo-stats";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mrbean-bremen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W6RhVnMuOgB4GNxczx3UlSeq0RWIM7yISKEvpnrE9uk=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
