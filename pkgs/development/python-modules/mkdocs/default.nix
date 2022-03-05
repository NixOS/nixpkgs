{
  # eval time deps
  lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
, Babel
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mkdocs";
  version = "1.2.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-LBw2ftGyeNvARQ8xiYUho8BiQh+aIEqROP51gKvNxEo=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/mkdocs/mkdocs/commit/c93fc91e4dc0ef33e2ea418aaa32b0584a8d354a.patch";
      sha256 = "sha256-7uLIuQOt6KU/+iS9cwhXkWPAHzZkQdMyNBxSMut5WK4=";
      excludes = [ "tox.ini" ];
    })
  ];

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
    Babel
    mock
  ];


  checkPhase = ''
    set -euo pipefail

    runHook preCheck

    python -m unittest discover -v -p '*tests.py' mkdocs --top-level-directory .

    runHook postCheck
  '';

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
