{
  # eval time deps
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # buildtime
  hatchling,

  # runtime deps
  click,
  ghp-import,
  jinja2,
  markdown,
  markupsafe,
  mergedeep,
  mkdocs-get-deps,
  packaging,
  pathspec,
  platformdirs,
  pyyaml,
  pyyaml-env-tag,
  watchdog,

  # optional-dependencies
  babel,
  setuptools,

  # testing deps
  mock,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "mkdocs";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = "mkdocs";
    tag = version;
    hash = "sha256-JQSOgV12iYE6FubxdoJpWy9EHKFxyKoxrm/7arCn9Ak=";
  };

  patches = [
    # https://github.com/mkdocs/mkdocs/pull/4065
    ./click-8.3.0-compat.patch
  ];

  build-system = [
    hatchling
    # babel, setuptools required as "build hooks"
    babel
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [ setuptools ];

  dependencies = [
    click
    ghp-import
    jinja2
    markdown
    markupsafe
    mergedeep
    mkdocs-get-deps
    packaging
    pathspec
    platformdirs
    pyyaml
    pyyaml-env-tag
    watchdog
  ];

  optional-dependencies = {
    i18n = [ babel ];
  };

  nativeCheckInputs = [
    unittestCheckHook
    mock
  ]
  ++ optional-dependencies.i18n;

  unittestFlagsArray = [
    "-v"
    "-p"
    "'*tests.py'"
    "mkdocs"
  ];

  pythonImportsCheck = [ "mkdocs" ];

  meta = {
    changelog = "https://github.com/mkdocs/mkdocs/releases/tag/${version}";
    description = "Project documentation with Markdown / static website generator";
    mainProgram = "mkdocs";
    downloadPage = "https://github.com/mkdocs/mkdocs";
    longDescription = ''
      MkDocs is a fast, simple and downright gorgeous static site generator that's
      geared towards building project documentation. Documentation source files
      are written in Markdown, and configured with a single YAML configuration file.

      MkDocs can also be used to generate general-purpose websites.
    '';
    homepage = "http://mkdocs.org/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ rkoe ];
  };
}
