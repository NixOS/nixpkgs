{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  nix-update-script,
  orjson,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  rustc,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "blastdns";
  version = "2.0.2-unstable-2026-10-21";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "blacklanternsecurity";
    repo = "blastdns";
    # https://github.com/blacklanternsecurity/blastdns/issues/142
    rev = "e5a9ab0c9dcbc82ccede5dc6eaf3d2db5b11d61a";
    hash = "sha256-lfEAnTR4SrVHY/XGW1MLkaMUT4aXd2kt0iOkwbAyYLQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-QGp4EqOEXSMSeE0ZT85SzpIGrhva//MXKEjZEd7oYgY=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

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
