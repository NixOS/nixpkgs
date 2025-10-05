{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  pydantic,
  python-dotenv,
  pytestCheckHook,
  pytest-examples,
  pytest-mock,
}:

let
  self = buildPythonPackage rec {
    pname = "pydantic-settings";
    version = "2.10.1";
    pyproject = true;

    disabled = pythonOlder "3.8";

    src = fetchFromGitHub {
      owner = "pydantic";
      repo = "pydantic-settings";
      tag = version;
      hash = "sha256-Bi5MIXB9fVE5hoyk8QxxaGa9+puAlW+YGdi/WMNf/RQ=";
    };

    build-system = [ hatchling ];

    dependencies = [
      pydantic
      python-dotenv
    ];

    pythonImportsCheck = [ "pydantic_settings" ];

    nativeCheckInputs = [
      pytestCheckHook
      pytest-examples
      pytest-mock
    ];

    disabledTests = [
      # expected to fail
      "test_docs_examples[docs/index.md:212-246]"
    ];

    preCheck = ''
      export HOME=$TMPDIR
    '';

    # ruff is a dependency of pytest-examples which is required to run the tests.
    # We do not want all of the downstream packages that depend on pydantic-settings to also depend on ruff.
    doCheck = false;
    passthru.tests = {
      pytest = self.overridePythonAttrs { doCheck = true; };
    };

    meta = with lib; {
      description = "Settings management using pydantic";
      homepage = "https://github.com/pydantic/pydantic-settings";
      license = licenses.mit;
      broken = lib.versionOlder pydantic.version "2.0.0";
      maintainers = [ ];
    };
  };
in
self
