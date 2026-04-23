{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  pygithub,
}:

buildPythonPackage rec {
  pname = "ghrepo-stats";
  version = "0.5.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mrbean-bremen";
    repo = "ghrepo-stats";
    tag = "v${version}";
    hash = "sha256-zdBIX/uetkOAalg4uJPWXRL9WUgNN+hmqUwQDTdzrzA=";
  };

  postPatch = ''
    # https://github.com/mrbean-bremen/ghrepo-stats/pull/1
    substituteInPlace setup.py \
      --replace "bs4" "beautifulsoup4"
  '';

  propagatedBuildInputs = [
    beautifulsoup4
    matplotlib
    pygithub
  ];

  # Module has no tests
  doCheck = false;

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
