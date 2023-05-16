{ lib
<<<<<<< HEAD
, aws-sam-translator
, buildPythonPackage
, fetchFromGitHub
=======
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aws-sam-translator
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, jschema-to-python
, jsonpatch
, jsonschema
, junit-xml
<<<<<<< HEAD
, mock
, networkx
, pydot
, pytestCheckHook
, pythonOlder
, pyyaml
, regex
, sarif-om
, setuptools
, sympy
=======
, networkx
, pyyaml
, sarif-om
, setuptools
, six
, mock
, pydot
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "cfn-lint";
<<<<<<< HEAD
  version = "0.79.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.73.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "cfn-python-lint";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-5Lb8dA8HqDdEO/Ehv5y/JlP+te46mzrTw/kNHBb9l38=";
  };

=======
    hash = "sha256-CNB5LrXllGxy99NjCrbjkUXUpJ72U3pUnWqrqkOiCG8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "jsonschema~=3.0" "jsonschema>=3.0"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    aws-sam-translator
    jschema-to-python
    jsonpatch
    jsonschema
    junit-xml
    networkx
<<<<<<< HEAD
    networkx
    pyyaml
    regex
    sarif-om
    sympy
=======
    pyyaml
    sarif-om
    six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    mock
    pydot
    pytestCheckHook
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # These tests depend on the current date, for example because of issues like this.
    # This makes it possible for them to succeed on hydra and then begin to fail without
    # any code changes.
    # https://github.com/aws-cloudformation/cfn-python-lint/issues/1705
    # See also: https://github.com/NixOS/nixpkgs/issues/108076
    "TestQuickStartTemplates"
<<<<<<< HEAD
    # Requires git directory
=======
    # requires git directory
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "test_update_docs"
    # Tests depend on network access (fails in getaddrinfo)
    "test_update_resource_specs_python_2"
    "test_update_resource_specs_python_3"
    "test_sarif_formatter"
<<<<<<< HEAD
    # Some CLI tests fails
    "test_bad_config"
    "test_override_parameters"
    "test_positional_template_parameters"
    "test_template_config"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "cfnlint"
<<<<<<< HEAD
=======
    "cfnlint.conditions"
    "cfnlint.core"
    "cfnlint.decode.node"
    "cfnlint.decode.cfn_yaml"
    "cfnlint.decode.cfn_json"
    "cfnlint.decorators.refactored"
    "cfnlint.graph"
    "cfnlint.helpers"
    "cfnlint.rules"
    "cfnlint.runner"
    "cfnlint.template"
    "cfnlint.transform"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Checks cloudformation for practices and behaviour that could potentially be improved";
    homepage = "https://github.com/aws-cloudformation/cfn-python-lint";
<<<<<<< HEAD
    changelog = "https://github.com/aws-cloudformation/cfn-lint/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
=======
    changelog = "https://github.com/aws-cloudformation/cfn-python-lint/blob/master/CHANGELOG.md";
    license = licenses.mit;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
