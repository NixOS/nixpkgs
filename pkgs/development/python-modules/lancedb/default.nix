{
  lib,
  stdenv,
  buildPythonPackage,
  rustPlatform,
  fetchFromGitHub,
  darwin,
  libiconv,
  openssl,
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
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lancedb";
    rev = "refs/tags/python-v${version}";
    hash = "sha256-lw2tZ26Py6JUxuetaokJKnxOv/WoLK4spxssLKxvxJA=";
  };

  buildAndTestSubdir = "python";

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  build-system = [ rustPlatform.maturinBuildHook ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.cargoSetupHook
  ];

  buildInputs =
    [
      libiconv
      openssl
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

  disabledTests =
    [
      # require tantivy which is not packaged in nixpkgs
      "test_basic"

      # polars.exceptions.ComputeError: TypeError: _scan_pyarrow_dataset_impl() got multiple values for argument 'batch_size'
      # https://github.com/lancedb/lancedb/issues/1539
      "test_polars"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # fail with darwin sandbox
      "test_async_remote_db"
      "test_http_error"
      "test_retry_error"
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
