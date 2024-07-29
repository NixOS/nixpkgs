{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools-scm,
  flake8,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-flake8";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "coherent-oss";
    repo = "pytest-flake8";
    rev = "refs/tags/v${version}";
    hash = "sha256-VNefGRB++FZFIGOS8Pyxbfe0zAXqwy+p6uERE70+CT4=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ flake8 ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/coherent-oss/pytest-flake8/issues/2
    "test_version"
    "test_default_flake8_ignores"
    "test_ignores_all"
    "test_w293w292"
    "test_mtime_caching"
    "test_ok_verbose"
    "test_keyword_match"
    "test_run_on_init_file"
    "test_unicode_error"
    "test_junit_classname"
  ];

  meta = {
    changelog = "https://github.com/coherent-oss/pytest-flake8/blob/${src.rev}/NEWS.rst";
    description = "py.test plugin for efficiently checking PEP8 compliance";
    homepage = "https://github.com/coherent-oss/pytest-flake8";
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
