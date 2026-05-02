{
  stdenv,
  apple-sdk_15,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pkg-config,
  pytestCheckHook,
  rustPlatform,
}:
buildPythonPackage rec {
  pname = "pyoxigraph";
  pyproject = true;
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "oxigraph";
    repo = "oxigraph";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-FqGlhU23tvDUClGq8pe7tgdlrnyHMm+2QeFLbnd26/o=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-QiEMndJQZQ0DWDOkbykhvzq8QfEoM2wlwUWnG3IUHbY=";
  };

  buildAndTestSubdir = "python";

  dependencies = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

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

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "pyoxigraph" ];

  meta = {
    homepage = "https://github.com/oxigraph/oxigraph";
    description = "SPARQL graph database";
    maintainers = with lib.maintainers; [ dadada ];
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = lib.platforms.unix;
  };
}
