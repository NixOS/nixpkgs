{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  babel,
  gitpython,
  mkdocs,
  pytz,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mkdocs-git-revision-date-localized-plugin";
<<<<<<< HEAD
  version = "1.5.0";
=======
  version = "1.4.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "timvink";
    repo = "mkdocs-git-revision-date-localized-plugin";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-3Txfb4ErY8moCBlXp6DgrL5BXTggu8XMa3sU4AfRS8U=";
=======
    hash = "sha256-xSm+Qvk1DU5CEZpR+69oIAKnIrg/J7iECNHEZQlf/7o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    babel
    gitpython
    mkdocs
    pytz
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "tests/test_builds.py" ];

  pythonImportsCheck = [ "mkdocs_git_revision_date_localized_plugin" ];

<<<<<<< HEAD
  meta = {
    description = "MkDocs plugin that enables displaying the date of the last git modification of a page";
    homepage = "https://github.com/timvink/mkdocs-git-revision-date-localized-plugin";
    changelog = "https://github.com/timvink/mkdocs-git-revision-date-localized-plugin/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ totoroot ];
=======
  meta = with lib; {
    description = "MkDocs plugin that enables displaying the date of the last git modification of a page";
    homepage = "https://github.com/timvink/mkdocs-git-revision-date-localized-plugin";
    changelog = "https://github.com/timvink/mkdocs-git-revision-date-localized-plugin/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ totoroot ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
