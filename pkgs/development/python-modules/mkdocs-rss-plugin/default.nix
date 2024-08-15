{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonPackage rec {
  pname = "mkdocs-rss-plugin";
  version = "1.8.0";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Guts";
    repo = "mkdocs-rss-plugin";
    rev = "refs/tags/${version}";
    hash = "sha256-rCz1Uk5uqIsnIWw0b1oBsjAO6aK/tpVgqAX/8dVnAGw=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  propagatedBuildInputs = with python3Packages; [
    mkdocs
    gitpython
  ];

  doCheck = false;

  meta = with lib; {
    description = "Plugin to generate a RSS feeds for created and updated pages";
    longDescription = ''
      MkDocs plugin to generate a RSS feeds for created and updated pages, using
      git log and YAML frontmatter (page.meta).
    '';
    homepage = "https://github.com/Guts/mkdocs-rss-plugin";
    changelog = "https://github.com/Guts/mkdocs-rss-plugin/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ caarlos0 ];
  };
}
