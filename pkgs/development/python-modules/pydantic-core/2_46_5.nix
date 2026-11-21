{
  lib,
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  typing-extensions,
  pydantic,
  pytestCheckHook,
  hypothesis,
  inline-snapshot,
  pytest-benchmark,
  pytest-run-parallel,
  pytest-timeout,
  pytest-mock,
  dirty-equals,
  typing-inspection,
}:

let
  pydantic-core = buildPythonPackage rec {
    pname = "pydantic-core";
    version = "2.46.5";
    pyproject = true;
    strictDeps = true;
    __structuredAttrs = true;

    src = fetchPypi {
      pname = "pydantic_core";
      inherit version;
      hash = "sha256-EEFsFbiDnsxO9NCIXadtpv0PZzM6Driv9tk8S48pEPw=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit pname version src;
      hash = "sha256-h955lauGYYxIN9hPQXGRESFa4sYvcyPsHxCTMCFSMXs=";
    };

    postPatch = ''
      for testFile in tests/benchmarks/test_micro_benchmarks.py tests/benchmarks/test_serialization_micro.py tests/validators/test_union.py; do
        sed -i "/^    @pytest.fixture(scope='class')$/a\\    @classmethod" "$testFile"
      done
    '';

    nativeBuildInputs = [
      rustPlatform.cargoSetupHook
      rustPlatform.maturinBuildHook
    ];

    dependencies = [ typing-extensions ];

    pythonImportsCheck = [ "pydantic_core" ];

    # Match the primary package: keep its check derivation available without
    # making every consumer of this scoped core package inherit the test closure.
    doCheck = false;
    passthru.tests.pytest = pydantic-core.overridePythonAttrs { doCheck = true; };

    nativeCheckInputs = [
      pytestCheckHook
      hypothesis
      inline-snapshot
      pytest-timeout
      dirty-equals
      pytest-benchmark
      pytest-mock
      pytest-run-parallel
      typing-inspection
    ];

    meta = {
      description = "Core validation logic for pydantic written in Rust";
      homepage = "https://github.com/pydantic/pydantic/tree/main/pydantic-core";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ philocalyst ];
    };
  };
in
pydantic-core
