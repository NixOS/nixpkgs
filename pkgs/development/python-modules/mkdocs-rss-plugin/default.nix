{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage {
  pname = "mkdocs-rss-plugin";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "Guts";
    repo = "mkdocs-rss-plugin";
    rev = "1.8.0";
    sha256 = "sha256-rCz1Uk5uqIsnIWw0b1oBsjAO6aK/tpVgqAX/8dVnAGw=";
  };


  doCheck = false;

  meta = with lib; {
    description = "MkDocs plugin to generate a RSS feeds for created and updated pages, using git log and YAML frontmatter (page.meta).";
    homepage = "https://github.com/Guts/mkdocs-rss-plugin";
    license = licenses.mit;
    maintainers = with maintainers; [ caarlos0 ];
  };
}
