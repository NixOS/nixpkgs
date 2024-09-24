{
  lib,
  stdenv,
  buildPythonPackage,
  rustPlatform,
  fetchFromGitHub,
  darwin,
  libiconv,
  pkg-config,
  protobuf,
  attrs,
  cachetools,
  deprecation,
  overrides,
  packaging,
  pydantic,
  pylance,
  requests,
  retry,
  tqdm,
  aiohttp,
  pandas,
  polars,
  pytest-asyncio,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "lancedb";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lancedb";
    rev = "refs/tags/python-v${version}";
    hash = "sha256-6E20WgyoEALdxmiOfgq89dCkqovvIMzc/wy+kvjDWwU=";
  };

  buildAndTestSubdir = "python";

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  build-system = [ rustPlatform.maturinBuildHook ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  buildInputs =
    [
      libiconv
      protobuf
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        IOKit
        Security
        SystemConfiguration
      ]
    );

  dependencies = [
    attrs
    cachetools
    deprecation
    overrides
    packaging
    pydantic
    pylance
    requests
    retry
    tqdm
  ];

  pythonImportsCheck = [ "lancedb" ];

  nativeCheckInputs = [
    aiohttp
    pandas
    polars
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    cd python/python/tests
  '';

  pytestFlagsArray = [ "-m 'not slow'" ];

  disabledTests = [
    # require tantivy which is not packaged in nixpkgs
    "test_basic"

    # polars.exceptions.ComputeError: TypeError: _scan_pyarrow_dataset_impl() got multiple values for argument 'batch_size'
    # https://github.com/lancedb/lancedb/issues/1539
    "test_polars"
  ];

  disabledTestPaths = [
    # touch the network
    "test_s3.py"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "python-v(.*)"
      "--generate-lockfile"
      "--lockfile-metadata-path"
      "python"
    ];
  };

  meta = {
    description = "Developer-friendly, serverless vector database for AI applications";
    homepage = "https://github.com/lancedb/lancedb";
    changelog = "https://github.com/lancedb/lancedb/releases/tag/python-v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
