{
<<<<<<< HEAD
=======
  stdenv,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
<<<<<<< HEAD
  typing-extensions,
  pytestCheckHook,
  hypothesis,
  inline-snapshot,
  pytest-benchmark,
  pytest-run-parallel,
=======
  libiconv,
  typing-extensions,
  pytestCheckHook,
  hypothesis,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytest-timeout,
  pytest-mock,
  dirty-equals,
  pydantic,
<<<<<<< HEAD
  typing-inspection,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

let
  pydantic-core = buildPythonPackage rec {
    pname = "pydantic-core";
<<<<<<< HEAD
    version = "2.41.5";
=======
    version = "2.33.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pyproject = true;

    src = fetchFromGitHub {
      owner = "pydantic";
      repo = "pydantic-core";
      tag = "v${version}";
<<<<<<< HEAD
      hash = "sha256-oIYHLSep8tWOXEaUybXG8Gv9WBoPGQ1Aj7QyqYksvMw=";
=======
      hash = "sha256-2jUkd/Y92Iuq/A31cevqjZK4bCOp+AEC/MAnHSt2HLY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit pname version src;
<<<<<<< HEAD
      hash = "sha256-Kvc0a34C6oGc9oS/iaPaazoVUWn5ABUgrmPa/YocV+Y=";
=======
      hash = "sha256-MY6Gxoz5Q7nCptR+zvdABh2agfbpqOtfTtor4pmkb9c=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };

    nativeBuildInputs = [
      cargo
      rustPlatform.cargoSetupHook
<<<<<<< HEAD
      rustPlatform.maturinBuildHook
      rustc
    ];

=======
      rustc
    ];

    build-system = [
      rustPlatform.maturinBuildHook
      typing-extensions
    ];

    buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    dependencies = [ typing-extensions ];

    pythonImportsCheck = [ "pydantic_core" ];

<<<<<<< HEAD
    # escape infinite recursion with pydantic via inline-snapshot
    doCheck = false;
    passthru.tests.pytest = pydantic-core.overridePythonAttrs { doCheck = true; };
=======
    # escape infinite recursion with pydantic via dirty-equals
    doCheck = false;
    passthru.tests.pytest = pydantic-core.overrideAttrs { doCheck = true; };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    nativeCheckInputs = [
      pytestCheckHook
      hypothesis
<<<<<<< HEAD
      inline-snapshot
      pytest-timeout
      dirty-equals
      pytest-benchmark
      pytest-mock
      pytest-run-parallel
      typing-inspection
    ];

    meta = {
      changelog = "https://github.com/pydantic/pydantic-core/releases/tag/${src.tag}";
      description = "Core validation logic for pydantic written in rust";
      homepage = "https://github.com/pydantic/pydantic-core";
      license = lib.licenses.mit;
      inherit (pydantic.meta) maintainers;
=======
      pytest-timeout
      dirty-equals
      pytest-mock
    ];

    disabledTests = [
      # RecursionError: maximum recursion depth exceeded while calling a Python object
      "test_recursive"
    ];

    disabledTestPaths = [
      # no point in benchmarking in nixpkgs build farm
      "tests/benchmarks"
    ];

    meta = with lib; {
      changelog = "https://github.com/pydantic/pydantic-core/releases/tag/v${version}";
      description = "Core validation logic for pydantic written in rust";
      homepage = "https://github.com/pydantic/pydantic-core";
      license = licenses.mit;
      maintainers = pydantic.meta.maintainers;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };
  };
in
pydantic-core
