{
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pkg-config,
  pythonAtLeast,
  pytestCheckHook,
  rustPlatform,
  IOKit,
  Security,
}:
buildPythonPackage rec {
  pname = "pyoxigraph";
  pyproject = true;
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "oxigraph";
    repo = "oxigraph";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-EG9VLDS9BhgPwr2Z7SGWe9l9j5Yg9KdRysvd9KGQDgk=";
  };

  buildAndTestSubdir = "python";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-iuMJ0nGixncIwKzD8wVwMlJ4MIsdv0kdIMjnBI/82HI=";
  };

  dependencies = lib.optionals stdenv.hostPlatform.isDarwin [
    IOKit
    Security
  ];
  disabled = !pythonAtLeast "3.8";

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

  meta = with lib; {
    homepage = "https://github.com/oxigraph/oxigraph";
    description = "SPARQL graph database";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with maintainers; [ dadada ];
    license = with licenses; [
      asl20
      mit
    ];
  };
}
