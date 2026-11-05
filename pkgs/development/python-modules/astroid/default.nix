{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pip,
  pylint,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "astroid";
  version = "4.3.4"; # Check whether the version is compatible with pylint
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pylint-dev";
    repo = "astroid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+H7OZa5AxIzz+EhiutlW7YQQ6nR+c2AVb39DHL6xQ8o=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pip
    pytestCheckHook
  ];

  disabledTests = [
    # UserWarning: pkg_resources is deprecated as an API. See https://setuptools.pypa.io/en/latest/pkg_resources.html.
    "test_identify_old_namespace_package_protocol"
    # astroid.exceptions.AttributeInferenceError: '__required_keys__' not found on <ClassDef.CustomTD2 l.8 at 0x7ffff23a9130>.
    "test_typed_dict_required_and_optional_keys"
  ];

  disabledTestPaths = [
    # requires mypy
    "tests/test_raw_building.py"
  ];

  passthru.tests = {
    inherit pylint;
  };

  meta = {
    changelog = "https://github.com/pylint-dev/astroid/blob/${finalAttrs.src.tag}/ChangeLog";
    description = "Abstract syntax tree for Python with inference support";
    homepage = "https://github.com/pylint-dev/astroid";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
