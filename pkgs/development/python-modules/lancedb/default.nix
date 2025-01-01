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
}:

buildPythonPackage rec {
  pname = "lancedb";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lancedb";
    rev = "refs/tags/python-v${version}";
    hash = "sha256-RWmvqGm/Bekajb/fs/PQJ2fL0Vo1Mmy+x40PKaDmIEU=";
  };

  # ratelimiter only support up to python310 and it has been removed from nixpkgs
  patches = [ ./remove-ratelimiter.patch ];

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
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        IOKit
        Security
        SystemConfiguration
      ]
    );

  pythonRemoveDeps = [ "ratelimiter" ];

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
  ];

  disabledTestPaths = [
    # touch the network
    "test_s3.py"
  ];

  meta = {
    description = "Developer-friendly, serverless vector database for AI applications";
    homepage = "https://github.com/lancedb/lancedb";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
