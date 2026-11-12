{
  lib,
  attrs,
  buildPythonPackage,
  docutils,
  fetchPypi,
  od,
  pygments,
  pythonAtLeast,
  python-dateutil,
  repeated-test,
  setuptools-scm,
  sigtools,
  unittestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "clize";
  version = "5.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-BH9aRHNgJxirG4VnKn4VMDOHF41agcJ13EKd+sHstRA=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    attrs
    docutils
    od
    sigtools
  ];

  optional-dependencies = {
    datetime = [ python-dateutil ];
  };

  nativeCheckInputs = [
    pygments
    unittestCheckHook
    python-dateutil
    repeated-test
  ];

  unittestFlags =
    let
      disabledTests = [
        "test_help.ElementsFromAutodetectedDocstringTests.test_sphinx_has_sphinx_error_in_param_desc"
        "test_help.ElementsFromAutodetectedDocstringTests.test_sphinx_has_sphinx_error_in_free_text"
        "test_help.ElementsFromAutodetectedDocstringTests.test_clize_sphinx_error"
        "test_help.ElementsFromAutodetectedDocstringTests.test_clize_has_sphinx_error"
      ]
      ++ lib.optionals (pythonAtLeast "3.14") [
        "test_help.ClizeWholeHelpTests.test_custom_param_help"
      ];
      matchingPattern = builtins.concatStringsSep "|" disabledTests;
    in
    [
      "-s clize/tests"
      "-k [!(${matchingPattern})]"
    ];

  pythonImportsCheck = [ "clize" ];

  meta = {
    description = "Command-line argument parsing for Python";
    homepage = "https://github.com/epsy/clize";
    changelog = "https://github.com/epsy/clize/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
