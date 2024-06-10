{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # build system
  setuptools,

  # dependencies
  cssutils,
  lxml,
  requests,

  # tests
  ipdb,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "inlinestyler";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dlanger";
    repo = "inlinestyler";
    rev = "refs/tags/${version}";
    hash = "sha256-9TKXqW+5SiiNXnHW2lOVh3zhFhodM7a1UB2yXsEuX3I=";
  };

  patches = [
    # https://github.com/dlanger/inlinestyler/pull/33
    (fetchpatch2 {
      url = "https://github.com/dlanger/inlinestyler/commit/29fc1c256fd8f37c3e2fda34c975f0bcfe72cf9a.patch";
      hash = "sha256-35GWrfvXgpy1KAZ/0pdxsiKNTpDku6/ZX3KWfRUGQmc=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    cssutils
    lxml
    requests
  ];

  pythonImportsCheck = [ "inlinestyler" ];

  nativeCheckInputs = [
    ipdb
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Simple CSS inliner for generating HTML email messages";
    homepage = "https://github.com/dlanger/inlinestyler";
    changelog = "https://github.com/dlanger/inlinestyler/blob/${src.rev}/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
