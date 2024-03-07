{ lib
, buildPythonPackage
, fetchFromGitHub
, pytoolconfig
, pytest-timeout
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "rope";
  version = "1.12.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "python-rope";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-j/9q2S2B3DzmEqMOBLG9iHwnLqZipcPxLaKppysJffA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pytoolconfig
  ] ++ pytoolconfig.optional-dependencies.global;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    "test_search_submodule"
    "test_get_package_source_pytest"
    "test_get_modname_folder"
  ];

  meta = with lib; {
    description = "Python refactoring library";
    homepage = "https://github.com/python-rope/rope";
    changelog = "https://github.com/python-rope/rope/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ goibhniu ];
  };
}
