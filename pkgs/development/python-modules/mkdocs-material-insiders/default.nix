{
  # Evaluation
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # Build
  hatchling,
  hatch-requirements-txt,
  hatch-nodejs-version,
  trove-classifiers,

  # Dependencies
  jinja2,
  markdown,
  mkdocs,
  mkdocs-material-extensions,
  pygments,
  pymdown-extensions,
  babel,
  colorama,
  mergedeep,
  paginate,
  regex,
  requests,

  # Optional dependencies
  mkdocs-minify-plugin,
  mkdocs-redirects,
  mkdocs-rss-plugin,
  mkdocs-git-committers-plugin-2,
  mkdocs-git-revision-date-localized-plugin,
  pillow,
  cairosvg,
}:

buildPythonPackage rec {
  pname = "mkdocs-material";
  version = "9.5.36-insiders-4.53.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "squidfunk";
    repo = "mkdocs-material-insiders";
    private = true;
    rev = "refs/tags/${version}";
    hash = "sha256-jmu3TftFtNwLTTy1O14+nDQtyqlUB3uUTrFYlEsFM1A=";
  };

  disabled = !pythonAtLeast "3.8";

  nativeBuildInputs = [
    hatchling
    hatch-requirements-txt
    hatch-nodejs-version
    trove-classifiers
  ];

  propagatedBuildInputs = [
    jinja2
    markdown
    mkdocs
    mkdocs-material-extensions
    pygments
    pymdown-extensions
    babel
    colorama
    mergedeep
    paginate
    regex
    requests
  ];

  passthru.optional-dependencies = {
    recommended = [
      mkdocs-minify-plugin
      mkdocs-redirects
      mkdocs-rss-plugin
    ];

    git = [
      mkdocs-git-committers-plugin-2
      mkdocs-git-revision-date-localized-plugin
    ];

    imaging = [
      pillow
      cairosvg
    ];
  };

  pythonImportsCheck = [ "material" ];

  meta = {
    changelog = "https://github.com/squidfunk/mkdocs-material-insiders/blob/${version}/CHANGELOG";
    description = "Sponsor's edition of Material for MkDocs";
    downloadPage = "https://github.com/squidfunk/mkdocs-material-insiders";
    homepage = "https://squidfunk.github.io/mkdocs-material/insiders";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahtaran ];
  };
}
