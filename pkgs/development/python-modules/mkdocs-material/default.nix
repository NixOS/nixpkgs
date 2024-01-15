{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, hatch-requirements-txt
, hatch-nodejs-version
, hatchling
, trove-classifiers

# dependencies
, babel
, colorama
, jinja2
, markdown
, mkdocs
, mkdocs-material-extensions
, paginate
, pygments
, pymdown-extensions
, pythonOlder
, regex
, requests

# optional-dependencies
, mkdocs-minify-plugin
, mkdocs-redirects
, mkdocs-git-revision-date-localized-plugin
, pillow
, cairosvg
}:

buildPythonPackage rec {
  pname = "mkdocs-material";
  version = "9.4.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "squidfunk";
    repo = "mkdocs-material";
    rev = "refs/tags/${version}";
    hash = "sha256-oP0DeSRgoLx6boEOa3if5BitGXmJ11DoUVZK16Sjlwg=";
  };

  nativeBuildInputs = [
    hatch-requirements-txt
    hatch-nodejs-version
    hatchling
    trove-classifiers
  ];

  propagatedBuildInputs = [
    babel
    colorama
    jinja2
    markdown
    mkdocs
    mkdocs-material-extensions
    paginate
    pygments
    pymdown-extensions
    regex
    requests
  ];

  passthru.optional-dependencies = {
    recommended = [
      mkdocs-minify-plugin
      mkdocs-redirects
      # TODO: mkdocs-rss-plugin
    ];
    git = [
      # TODO: gmkdocs-git-committers-plugin
      mkdocs-git-revision-date-localized-plugin
    ];
    imaging = [
      cairosvg
      pillow
    ];
  };

  # No tests for python
  doCheck = false;

  pythonImportsCheck = [
    "mkdocs"
  ];

  meta = with lib; {
    changelog = "https://github.com/squidfunk/mkdocs-material/blob/${src.rev}/CHANGELOG";
    description = "Material for mkdocs";
    downloadPage = "https://github.com/squidfunk/mkdocs-material";
    homepage = "https://squidfunk.github.io/mkdocs-material/";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion ];
  };
}
