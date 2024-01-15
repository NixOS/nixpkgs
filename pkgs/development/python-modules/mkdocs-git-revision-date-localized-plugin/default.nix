{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, gitpython
, mkdocs
, pytz
, pytestCheckHook
, git
}:

buildPythonPackage rec {
  pname = "mkdocs-git-revision-date-localized-plugin";
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timvink";
    repo = "mkdocs-git-revision-date-localized-plugin";
    rev = "refs/tags/v${version}";
    hash = "sha256-6qLVmmJzMTrvuoeSVUjWqmI6f5MbAFWAj36v2l3ZeD8=";
  };

  propagatedBuildInputs = [
    gitpython
    mkdocs
    pytz
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    "tests/test_builds.py"
  ];

  pythonImportsCheck = [ "mkdocs_git_revision_date_localized_plugin" ];

  meta = with lib; {
    description = "MkDocs plugin that enables displaying the date of the last git modification of a page";
    homepage = "https://github.com/timvink/mkdocs-git-revision-date-localized-plugin";
    changelog = "https://github.com/timvink/mkdocs-git-revision-date-localized-plugin/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ totoroot ];
  };
}
