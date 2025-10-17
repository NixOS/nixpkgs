{
  lib,
  babel,
  backrefs,
  buildPythonPackage,
  cairosvg,
  colorama,
  fetchFromGitHub,
  hatch-nodejs-version,
  hatch-requirements-txt,
  hatchling,
  jinja2,
  markdown,
  mkdocs,
  mkdocs-git-revision-date-localized-plugin,
  mkdocs-material-extensions,
  mkdocs-minify-plugin,
  mkdocs-redirects,
  mkdocs-rss-plugin,
  paginate,
  pillow,
  pygments,
  pymdown-extensions,
  regex,
  requests,
  trove-classifiers,
}:

buildPythonPackage rec {
  pname = "mkdocs-material";
  version = "9.6.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "squidfunk";
    repo = "mkdocs-material";
    tag = version;
    hash = "sha256-zd1KJQOH3uHrePJbBgLuq++GSoM1KYW9VwpYnCrZZQY=";
  };

  build-system = [
    hatch-requirements-txt
    hatch-nodejs-version
    hatchling
    trove-classifiers
  ];

  dependencies = [
    babel
    backrefs
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

  pythonRelaxDeps = [ "backrefs" ];

  optional-dependencies = {
    recommended = [
      mkdocs-minify-plugin
      mkdocs-redirects
      mkdocs-rss-plugin
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

  pythonImportsCheck = [ "mkdocs" ];

  meta = with lib; {
    changelog = "https://github.com/squidfunk/mkdocs-material/blob/${src.tag}/CHANGELOG";
    description = "Material for mkdocs";
    downloadPage = "https://github.com/squidfunk/mkdocs-material";
    homepage = "https://squidfunk.github.io/mkdocs-material/";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion ];
  };
}
