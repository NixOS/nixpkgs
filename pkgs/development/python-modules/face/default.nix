{
  lib,
  buildPythonPackage,
  fetchPypi,
  boltons,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "face";
  version = "26.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rhITb/AFLxJIEfUxlnCo2dKbfSyqqr5UKBNpCWfMa8o=";
  };

  build-system = [ setuptools ];

  dependencies = [ boltons ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "face" ];

  disabledTests = [
    # Assertion error as we take the Python release into account
    "test_search_prs_basic"
    "test_module_shortcut"
  ];

  meta = {
    description = "Command-line interface parser and framework";
    longDescription = ''
      A command-line interface parser and framework, friendly for
      users, full-featured for developers.
    '';
    homepage = "https://github.com/mahmoud/face";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ twey ];
  };
}
