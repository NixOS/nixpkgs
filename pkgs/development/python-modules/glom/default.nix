{
  lib,
  attrs,
  boltons,
  buildPythonPackage,
  face,
  fetchPypi,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  pyyaml,
  setuptools,
  tomli,
}:

buildPythonPackage rec {
  pname = "glom";
  version = "24.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QyX5Z1mpEgRK97bGvQ26RK2MHrYDiqsFcylmHSAhuyc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    boltons
    attrs
    face
  ];

  optional-dependencies = {
    toml = lib.optionals (pythonOlder "3.11") [ tomli ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  preCheck = ''
    # test_cli.py checks the output of running "glom"
    export PATH=$out/bin:$PATH
  '';

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    "test_regular_error_stack"
    "test_long_target_repr"
    "test_glom_error_stack"
    "test_glom_error_double_stack"
    "test_branching_stack"
    "test_midway_branch"
    "test_partially_failing_branch"
    "test_coalesce_stack"
    "test_nesting_stack"
    "test_3_11_byte_code_caret"
  ];

  pythonImportsCheck = [ "glom" ];

  meta = with lib; {
    description = "Module for restructuring data";
    longDescription = ''
      glom helps pull together objects from other objects in a
      declarative, dynamic, and downright simple way.
    '';
    homepage = "https://github.com/mahmoud/glom";
    changelog = "https://github.com/mahmoud/glom/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ twey ];
    mainProgram = "glom";
  };
}
