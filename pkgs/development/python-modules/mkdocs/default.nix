{
  # eval time deps
  lib
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, pythonOlder

# buildtime
, hatchling

# runtime deps
, click
, ghp-import
, importlib-metadata
, jinja2
, markdown
, markupsafe
, mergedeep
, packaging
, pathspec
, platformdirs
, pyyaml
, pyyaml-env-tag
, watchdog

# optional-dependencies
, babel
, setuptools

# testing deps
, mock
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "mkdocs";
  version = "1.5.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-axH4AeL+osxoUIVJbW6YjiTfUr6TAXMB4raZ3oO0fyw=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    click
    ghp-import
    jinja2
    markdown
    markupsafe
    mergedeep
    packaging
    pathspec
    platformdirs
    pyyaml
    pyyaml-env-tag
    watchdog
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  passthru.optional-dependencies = {
    i18n = [
      babel
    ] ++ lib.optionals (pythonAtLeast "3.12") [
      setuptools
    ];
  };

  nativeCheckInputs = [
    unittestCheckHook
    mock
  ] ++ passthru.optional-dependencies.i18n;

  unittestFlagsArray = [ "-v" "-p" "'*tests.py'" "mkdocs" ];

  pythonImportsCheck = [ "mkdocs" ];

  meta = with lib; {
    changelog = "https://github.com/mkdocs/mkdocs/releases/tag/${version}";
    description = "Project documentation with Markdown / static website generator";
    downloadPage = "https://github.com/mkdocs/mkdocs";
    longDescription = ''
      MkDocs is a fast, simple and downright gorgeous static site generator that's
      geared towards building project documentation. Documentation source files
      are written in Markdown, and configured with a single YAML configuration file.

      MkDocs can also be used to generate general-purpose websites.
    '';
    homepage = "http://mkdocs.org/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rkoe ];
  };
}
