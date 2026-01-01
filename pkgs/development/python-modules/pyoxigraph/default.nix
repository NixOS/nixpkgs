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
<<<<<<< HEAD
  version = "0.5.3";
=======
  version = "0.5.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "oxigraph";
    repo = "oxigraph";
    tag = "v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-hIB4/6D7AogEpNYyB95nDotspUyaiOW8X6KuVgyjj5Y=";
=======
    hash = "sha256-ptTrJbLGS7GkLGO40mbpdPkrcspaUE33kRZ8g9Qtb0o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-EhJQgYeeSln1bLLH3nEUFJ7q+PWA/DHAswh4ei4bHWY=";
=======
    hash = "sha256-AuUGra9ejPRKWWpXWLmcwGuZRKIuCYTdifpnwuuHnnQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
