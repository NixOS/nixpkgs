{
  lib,
  stdenv,
  apple-sdk_15,
  buildPythonPackage,
  fetchFromGitHub,
  pkg-config,
  pytestCheckHook,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyoxigraph";
  pyproject = true;
  version = "0.5.10";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "oxigraph";
    repo = "oxigraph";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-2mThlPqjUJ3FuqzGRTfrN8af1NupSgdbWomyL5aMJTA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-iDt9wHJr6PMXGuCvLJqK9bRb3Y5gjuuSYdPhQofeJFQ=";
  };

  buildAndTestSubdir = "python";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyoxigraph" ];

  disabledTests = [
    "test_update_load"
  ];

  disabledTestPaths = [
    # These require network access
    "lints/test_spec_links.py"
    "lints/test_debian_compatibility.py"
    "oxrocksdb-sys/rocksdb/tools/block_cache_analyzer/block_cache_pysim_test.py"
    "oxrocksdb-sys/rocksdb/tools"
  ];

  meta = {
    description = "SPARQL graph database";
    homepage = "https://github.com/oxigraph/oxigraph";
    changelog = "https://github.com/oxigraph/oxigraph/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ dadada ];
    platforms = lib.platforms.unix;
  };
})
