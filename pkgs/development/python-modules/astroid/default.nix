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
  version = "3.3.11"; # Check whether the version is compatible with pylint
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "astroid";
    tag = "v${version}";
    hash = "sha256-lv+BQDYP7N4UGMf7XhB6HVDORPU0kZQPYveQWOcAqfQ=";
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

  meta = with lib; {
    changelog = "https://github.com/PyCQA/astroid/blob/v${version}/ChangeLog";
    description = "Abstract syntax tree for Python with inference support";
    homepage = "https://github.com/PyCQA/astroid";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
