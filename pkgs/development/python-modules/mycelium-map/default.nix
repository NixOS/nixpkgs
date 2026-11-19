{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  click,
  rich,
  pytest,
  python,
  pythonOlder,
}:

buildPythonPackage (finalAttrs: {
  pname = "mycelium-map";
  version = "0.5.0";
  pyproject = true;

  # Upstream requires Python 3.12 or newer.
  disabled = pythonOlder "3.12";

  # The PyPI sdist ships the crate test sources but not tests/fixtures, which two
  # of those tests pull in with include_str!("../../../tests/fixtures/..."), so
  # cargo test cannot even compile from it. The tag carries both.
  src = fetchFromGitHub {
    owner = "ScottRBK";
    repo = "mycelium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p2hyXfDBm5mqF+PzfON8IrwVvMR/1jGALG43KrCLLao=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-3ytpF12AqQhLJwUnHmSIVA2h5b/5GSDB8P8U/Srw7Tc=";
  };

  # abi3 module: the interpreter only selects the installation target. The built
  # extension has no libpython among its NEEDED entries, and it imports under
  # Python 3.12 and 3.14.
  env.PYO3_PYTHON = "${python.interpreter}";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  dependencies = [
    click
    rich
  ];

  nativeCheckInputs = [ pytest ];

  # Python packages have no checkPhase: buildPythonPackage reassigns checkPhase
  # to installCheckPhase, so everything goes here. Importing the CLI loads the
  # Rust extension, so --help also proves the module was built and linked.
  # importlib mode keeps pytest from prepending the source tree to sys.path,
  # which would shadow the built extension module with mycelium/. The checkpoint
  # suite drives the installed CLI through MYCELIUM_BIN and imports helpers from
  # the tests package, so it runs from a copy of tests/ where nothing can shadow
  # the installed mycelium. The wheel-specific tests/check_wheel.py needs uv and
  # a built wheel, so it is not run here.
  installCheckPhase = ''
    runHook preInstallCheck

    cargo test --workspace --offline
    pytest --import-mode=importlib tests/test_bindings.py

    mkdir -p "$NIX_BUILD_TOP/checkpoint-tests"
    cp -r tests "$NIX_BUILD_TOP/checkpoint-tests/tests"
    (
      cd "$NIX_BUILD_TOP/checkpoint-tests"
      MYCELIUM_BIN="$out/bin/mycelium-map" PYTHONPATH="$PWD" \
        pytest --import-mode=importlib tests/test_checkpoint_exports.py
    )

    $out/bin/mycelium-map --help > /dev/null

    runHook postInstallCheck
  '';

  pythonImportsCheck = [ "mycelium" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Static analysis tool that maps the hidden network of connections in codebases";
    homepage = "https://github.com/ScottRBK/mycelium";
    changelog = "https://github.com/ScottRBK/mycelium/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ twstagg ];
    mainProgram = "mycelium-map";
  };
})
