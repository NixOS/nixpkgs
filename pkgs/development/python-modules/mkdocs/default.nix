{ lib
, babel
, buildPythonPackage
, click
, fetchFromGitHub
, ghp-import
, hatchling
, importlib-metadata
, jinja2
, markdown
, mergedeep
, mock
, packaging
, pathspec
, platformdirs
, pythonOlder
, pyyaml
, pyyaml-env-tag
, unittestCheckHook
, watchdog
}:

buildPythonPackage rec {
  pname = "mkdocs";
  version = "1.5.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mkdocs";
    repo = "mkdocs";
    rev = "refs/tags/${version}";
    hash = "sha256-9sV1bewsHVJEc2kTyGxDM6SjDTEKEc/HSY6gWBC5tvE=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    click
    ghp-import
    importlib-metadata
    jinja2
    markdown
    mergedeep
    pathspec
    packaging
    platformdirs
    pyyaml
    pyyaml-env-tag
    watchdog
  ];

  nativeCheckInputs = [
    babel
    mock
    unittestCheckHook
  ];

  unittestFlagsArray = [
    "-v"
    "-p"
    "'*tests.py'"
    "mkdocs"
  ];

  pythonImportsCheck = [
    "mkdocs"
  ];

  meta = with lib; {
    description = "Project documentation with Markdown";
    longDescription = ''
      MkDocs is a fast, simple and downright gorgeous static site generator that's
      geared towards building project documentation. Documentation source files
      are written in Markdown, and configured with a single YAML configuration file.

      MkDocs can also be used to generate general-purpose websites.
    '';
    homepage = "http://mkdocs.org/";
    changelog = "https://github.com/mkdocs/mkdocs/releases/tag/${version}";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rkoe ];
  };
}
