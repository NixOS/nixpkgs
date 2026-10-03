{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  rustPlatform,

  # dependencies
  huggingface-hub,
  packaging,
  pyyaml,
  sigstore,
  tomlkit,

  # tests
  mktestdocs,
  pytest-benchmark,
  pytestCheckHook,
  torch,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "kernels";
  version = "0.17.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "kernels";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5+ixMEdGSg3k/3hafYUEpwpiq4ibEunf/IHczV7EsdE=";
  };

  sourceRoot = "${finalAttrs.src.name}/kernels";
  cargoRoot = "..";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      cargoRoot
      ;
    hash = "sha256-JWKJTlypMZf47OF8JIgGdCTfRTrpMr8rbyLDgS7bKz4=";
  };

  env = {
    CARGO_TARGET_DIR = "./target";
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [
    huggingface-hub
    packaging
    pyyaml
    sigstore
    tomlkit
  ];

  pythonImportsCheck = [ "kernels" ];

  nativeCheckInputs = [
    mktestdocs
    pytest-benchmark
    pytestCheckHook
    torch
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = [
    # Require internet access
    "tests/test_doctest.py"
    "tests/test_tvm_ffi.py"
    "tests/test_verify.py"
  ];

  disabledTests = [
    # Require internet access
    "test_deprecated_func_repository"
    "test_deprecated_local_kernel_func"
    "test_deps_validated_before_download"
    "test_download_all_hash_validation"
    "test_func_locked"
    "test_get_kernel_registers_loaded_kernel"
    "test_get_loaded_kernels_returns_copy"
    "test_get_local_kernel_registers_with_null_repo_info"
    "test_get_variants"
    "test_hub_cache_resolver_resolves_cached_kernel"
    "test_hub_cache_resolver_revision_passthrough"
    "test_hub_resolver_blocks_untrusted_org"
    "test_hub_resolver_no_matching_variant"
    "test_hub_resolver_resolves_remote_kernel"
    "test_hub_resolver_revision_passthrough"
    "test_illegal_dep"
    "test_info_hub"
    "test_install_kernel_offline_avoids_network"
    "test_install_kernel_offline_with_revision"
    "test_install_kernel_offline_with_version"
    "test_install_kernel_plus_import_does_not_set_repo_info"
    "test_install_kernel_skips_validation_by_default"
    "test_layer_locked"
    "test_layer_repository_trust_remote_code_allowlist_blocks_unlisted"
    "test_layer_versions"
    "test_local_kernel_validates_deps"
    "test_local_layer_repo"
    "test_local_overrides"
    "test_locked_hub_cache_resolver_requires_lock"
    "test_locked_hub_cache_resolver_resolves_locked_kernel"
    "test_locked_hub_resolver_requires_lock"
    "test_locked_hub_resolver_resolves_locked_revision"
    "test_repeated_get_kernel_is_cached"
    "test_trust_remote_code_allowlist_allows_untrusted"
    "test_trust_remote_code_allowlist_blocks_unlisted"
    "test_trust_remote_code_allows_trusted_org"
    "test_trust_remote_code_blocks_untrusted_org"
    "test_trust_remote_code_flag_allows_untrusted"
    "test_version"
  ];

  meta = {
    description = "Load compute kernels from the Huggingface Hub";
    homepage = "https://github.com/huggingface/kernels";
    changelog = "https://github.com/huggingface/kernels/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "kernels";
    maintainers = with lib.maintainers; [ osbm ];
  };
})
