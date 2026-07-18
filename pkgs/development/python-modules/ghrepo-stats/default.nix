{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  pygithub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ghrepo-stats";
  version = "0.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mrbean-bremen";
    repo = "ghrepo-stats";
    tag = "v${version}";
    hash = "sha256-zdBIX/uetkOAalg4uJPWXRL9WUgNN+hmqUwQDTdzrzA=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    matplotlib
    pygithub
  ];

  # Module has no tests
  doCheck = false;

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ghrepo_stats" ];

  meta = {
    description = "Python module and CLI tool for GitHub repo statistics";
    mainProgram = "show-ghstats";
    homepage = "https://github.com/mrbean-bremen/ghrepo-stats";
    changelog = "https://github.com/mrbean-bremen/ghrepo-stats/blob/v${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
