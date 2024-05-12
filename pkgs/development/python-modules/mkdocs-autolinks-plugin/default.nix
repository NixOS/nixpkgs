{ lib
, buildPythonPackage
, fetchFromGitHub
, mkdocs
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "mkdocs-autolinks-plugin";
  version = "0.7.1";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zachhannum";
    repo = "mkdocs-autolinks-plugin";
    # The commit messages mention version 0.7.1, but the tag is v_071.
    rev = "e2b649eb4db23459bcec121838f27c92c81f9ce1";
    hash = "sha256-mEbuB9VwK7po1TqtJfBSkItOVlI3/W3nD2LYRHgPpTA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [ mkdocs ];

  # Module has no tests.
  doCheck = false;

  pythonImportsCheck = [ "mkdocs_autolinks_plugin" ];

  meta = with lib; {
    description = "An MkDocs plugin that simplifies relative linking between documents";
    homepage = "https://github.com/zachhannum/mkdocs-autolinks-plugin";
    license = licenses.mit;
    maintainers = with maintainers; [ lucas-deangelis ];
  };
}
