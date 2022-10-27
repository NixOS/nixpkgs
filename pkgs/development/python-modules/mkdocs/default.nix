{
  # eval time deps
  lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
  # runtime deps
, click
, ghp-import
, importlib-metadata
, jinja2
, markdown
, mergedeep
, packaging
, pyyaml
, pyyaml-env-tag
, watchdog
  # testing deps
, babel
, mock
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "mkdocs";
  version = "1.3.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-S4xkr3jS5GvkMu8JnEGfqhmkxy3FtZZb7Rbuniltudg=";
  };

  propagatedBuildInputs = [
    click
    jinja2
    markdown
    mergedeep
    pyyaml
    pyyaml-env-tag
    ghp-import
    importlib-metadata
    watchdog
    packaging
  ];

  checkInputs = [
    unittestCheckHook
    babel
    mock
  ];

  unittestFlagsArray = [ "-v" "-p" "'*tests.py'" "mkdocs" ];

  pythonImportsCheck = [ "mkdocs" ];

  meta = with lib; {
    description = "Project documentation with Markdown / static website generator";
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
