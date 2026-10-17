{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,

  anyio,
  dirty-equals,
  inline-snapshot,
  opentelemetry-api,
  opentelemetry-sdk,
  pytest-examples,
  pytest-pretty,
  typing-extensions,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  # Since 0.0.20 the bindings ship as `pydantic-monty-client`; `pydantic-monty`
  # itself is only a metapackage pairing them with `pydantic-monty-runtime`,
  # whose `monty` binary `postInstall` puts in `$out/bin` below
  pname = "pydantic-monty-client";
  version = "1.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "monty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FqJIkEVmKeDWQyb/yrJ0+/2tZ1kCNe2Xc4r9UPgQptU=";
  };

  postPatch =
    # `&mut Box<[T; N]>` is not `IntoIterator` with the packaged Rust, although
    # upstream declares `rust-version = "1.96"`
    ''
      substituteInPlace crates/monty/src/modules/json/string_cache.rs \
        --replace-fail \
          "for entry in &mut inner.entries {" \
          "for entry in inner.entries.iter_mut() {"
    '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-kcL0aZ3U8ENQULVP3QBsQhBm+wSodLk0r3hw7HutubU=";
  };

  dependencies = [ typing-extensions ];

  optional-dependencies = {
    opentelemetry = [ opentelemetry-api ];
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  maturinBuildFlags = [
    "-m"
    "crates/monty-python/Cargo.toml"
  ];

  # The bindings spawn `monty subprocess` workers, and upstream ships that
  # binary in a separate `pydantic-monty-runtime` wheel that the `pydantic-monty`
  # metapackage pulls in: https://github.com/pydantic/monty/tree/main/crates/monty-runtime
  postBuild = ''
    cargo build --release --offline -p monty-runtime
  '';

  postInstall = ''
    install -Dm755 target/release/monty -t $out/bin
  '';

  pytestFlags = [
    "--config-file"
    "crates/monty-python/pyproject.toml"
    "-Wignore::pytest.PytestRemovedIn10Warning"
  ];

  # The tests resolve the worker binary the same way the bindings do at runtime
  preCheck = ''
    export MONTY_BIN=$out/bin/monty
  '';

  # `scripts/test_fixtures.py` is a helper for the Rust datatest harness, not a
  # test module, and importing it swaps `os.environ` for a stub that pytest
  # cannot write `PYTEST_CURRENT_TEST` to
  enabledTestPaths = [
    "crates/monty-python/tests"
  ];

  disabledTests = [
    # Lints the README snippets with whichever ruff is packaged, which is
    # stricter than the one upstream pins
    "test_readme_examples"

    # These tests fails because they expect to have multiple cores
    # to produce a predicted speedup measurement, which we cannot
    # achieve in the sandbox.
    "test_parallel_exec"
  ];

  nativeCheckInputs = [
    anyio
    dirty-equals
    inline-snapshot
    opentelemetry-sdk
    pytest-examples
    pytest-pretty
    pytestCheckHook
    websockets
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "pydantic_monty" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Minimal, secure Python interpreter written in Rust for use by AI";
    homepage = "https://github.com/pydantic/monty";
    changelog = "https://github.com/pydantic/monty/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ squat ];
  };
})
