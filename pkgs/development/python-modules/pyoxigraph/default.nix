{
  stdenv,
  apple-sdk_15,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pkg-config,
  pythonOlder,
  pytestCheckHook,
  rustPlatform,
}:
buildPythonPackage rec {
  pname = "pyoxigraph";
  pyproject = true;
  version = "0.4.11";

  src = fetchFromGitHub {
    owner = "oxigraph";
    repo = "oxigraph";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-M5C+SNZYXKfcosnRe9a+Zicyjuo6wli2uWv/SJxufJc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-TgeHmCMwXK+OlTGIyzus/N+MY29lgK+JuzUBwVFbpsI=";
  };

  buildAndTestSubdir = "python";

  dependencies = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  disabled = pythonOlder "3.8";

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
