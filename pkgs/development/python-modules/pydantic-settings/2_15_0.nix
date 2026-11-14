{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pydantic_2_13_5,
  python-dotenv,
  pytestCheckHook,
  pytest-examples,
  pytest-mock,
  azure-identity,
}:

let
  self = buildPythonPackage rec {
    pname = "pydantic-settings";
    version = "2.15.0";
    pyproject = true;
    strictDeps = true;
    __structuredAttrs = true;

    src = fetchPypi {
      pname = "pydantic_settings";
      inherit version;
      hash = "sha256-aUt5PoT3Zrp2qQ6978AdCpoEXasDgr7nA5Pak3Eq0Rc=";
    };

    build-system = [ hatchling ];

    dependencies = [
      pydantic_2_13_5
      python-dotenv
    ];

    pythonImportsCheck = [ "pydantic_settings" ];

    nativeCheckInputs = [
      pytestCheckHook
      pytest-examples
      pytest-mock
      azure-identity
    ];

    preCheck = ''
      export HOME=$TMPDIR
    '';

    # pytest-examples pulls in ruff; keep that test-only tool out of downstream
    # dependency closures while retaining an explicit check target.
    doCheck = false;
    passthru.tests.pytest = self.overridePythonAttrs { doCheck = true; };

    meta = {
      description = "Settings management using Pydantic";
      homepage = "https://github.com/pydantic/pydantic-settings";
      license = lib.licenses.mit;
    };
  };
in
self
