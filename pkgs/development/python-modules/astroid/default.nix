{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  typing-extensions,
  pip,
  pylint,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "astroid";
  version = "4.0.1"; # Check whether the version is compatible with pylint
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "astroid";
    tag = "v${version}";
    hash = "sha256-Ulifj+ym0j0LqhmKPfM8vVCjz71Gwd483ke3PkMnHb8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  nativeCheckInputs = [
    pip
    pytestCheckHook
  ];

  disabledTests = [
    # UserWarning: pkg_resources is deprecated as an API. See https://setuptools.pypa.io/en/latest/pkg_resources.html.
    "test_identify_old_namespace_package_protocol"
  ];

  disabledTestPaths = [
    # requires mypy
    "tests/test_raw_building.py"
  ];

  passthru.tests = {
    inherit pylint;
  };

  meta = {
    changelog = "https://github.com/PyCQA/astroid/blob/v${version}/ChangeLog";
    description = "Abstract syntax tree for Python with inference support";
    homepage = "https://github.com/PyCQA/astroid";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
