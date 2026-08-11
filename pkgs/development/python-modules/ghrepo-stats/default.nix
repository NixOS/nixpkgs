{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  pygithub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ghrepo-stats";
  version = "0.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mrbean-bremen";
    repo = "ghrepo-stats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zdBIX/uetkOAalg4uJPWXRL9WUgNN+hmqUwQDTdzrzA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    matplotlib
    pygithub
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ghrepo_stats" ];

  meta = {
    description = "Python module and CLI tool for GitHub repo statistics";
    homepage = "https://github.com/mrbean-bremen/ghrepo-stats";
    changelog = "https://github.com/mrbean-bremen/ghrepo-stats/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "show-ghstats";
  };
})
