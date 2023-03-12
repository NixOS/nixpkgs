{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, pygithub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ghrepo-stats";
  version = "0.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mrbean-bremen";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-65+Ah1DCEkIym2ehlZkubLIE+yJynlYNwE4g1IZ+AzM=";
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
