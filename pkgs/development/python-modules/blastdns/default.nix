{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  nix-update-script,
  orjson,
  pydantic,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  rustc,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "blastdns";
  version = "2.0.4";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "blacklanternsecurity";
    repo = "blastdns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zw1iHuQD2jPifrp16eWXE1WJ8PuYW1P+wS6hkODI1pY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Q2OZhiLi/UcTjHyxPWeI+rJTv9zPKh3X8G030rfgDVY=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    orjson
    pydantic
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # Run tests outside the source package path so imports resolve to the
  # installed wheel, which contains the compiled _native extension.
  preCheck = ''
    cd "$TMPDIR"
    cp -r /build/source/blastdns/tests ./tests
  '';

  pytestFlags = [
    "--import-mode=importlib"
    "tests"
  ];

  # Copying of the tests doesn't work on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  disabledTests = [
    # Tests requires host system DNS config files that are absent in sandboxed builds
    "test_client_resolve"
    "test_get_system_resolvers"
    "test_mock_matches_real_client"
    "test_stats_account_for_every_query"
    "test_zone_transfer_nonexistent_zone"
    "test_zone_transfer_success"
    # Flaky test
    "test_batch_size_1000"
  ];

  pythonImportsCheck = [ "blastdns" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ultra-fast DNS resolver";
    homepage = "https://github.com/blacklanternsecurity/blastdns";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
