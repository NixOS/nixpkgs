{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
  python,
  fetchPypi,
  autoPatchelfHook,

  # dependencies
  aiosignal,
  click,
  filelock,
  frozenlist,
  jsonschema,
  msgpack,
  packaging,
  protobuf,
  pyyaml,
  requests,
  watchfiles,

  # optional-dependencies
  # cgraph
  cupy,
  # client
  grpcio,
  # data
  fsspec,
  numpy,
  pandas,
  pyarrow,
  # default
  aiohttp,
  aiohttp-cors,
  colorful,
  opencensus,
  prometheus-client,
  pydantic,
  py-spy,
  smart-open,
  virtualenv,
  # observability
  memray,
  opentelemetry-api,
  opentelemetry-sdk,
  opentelemetry-exporter-otlp,
  # rllib
  dm-tree,
  gymnasium,
  lz4,
  # ormsgpack,
  scipy,
  typer,
  rich,
  # serve
  fastapi,
  starlette,
  uvicorn,
  # serve-grpc
  pyopenssl,
  # tune
  tensorboardx,
}:

let
  pname = "ray";
  version = "2.42.0";
in
buildPythonPackage rec {
  inherit pname version;
  format = "wheel";

  disabled = pythonOlder "3.9" || pythonAtLeast "3.13";

  src =
    let
      pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
      platforms = {
        aarch64-darwin = "macosx_11_0_arm64";
        aarch64-linux = "manylinux2014_aarch64";
        x86_64-darwin = "macosx_10_15_x86_64";
        x86_64-linux = "manylinux2014_x86_64";
      };
      # hashes retrieved via the following command
      # curl https://pypi.org/pypi/ray/${version}/json | jq -r '.urls[] | "\(.digests.sha256)  \(.filename)"'
      hashes = {
        aarch64-darwin = {
          cp39 = "4835c58b2e14f70badc059e9a6310cbfb51dec7a5b20fe712a4d193c85c9b2c5";
          cp310 = "4bb3d88c478dd2cc3a17a66f0c47a73978608ce5579f92f77a468720763c2331";
          cp311 = "7de151d403f351bb0fe3ed6f3f0e0258ce989871c60e4ccca2ab5bab7e9fc820";
          cp312 = "4a3ab3d73541c4e1b8c0dca31d4006ba18b20ccf7eb7a7428f5dbf96e9736a83";
        };
        aarch64-linux = {
          cp39 = "sha256-NlE3pzeWzz6DlS2Y6Gv8W+1DRMjK1a9T2R9lvq5nL7g=";
          cp310 = "sha256-MxCDruyfxiqy/Fkn0YM1idpZNUvChx8Xt6EBie7Q2uY=";
          cp311 = "sha256-eb9KDQIX6i2O/UfeZ9nCKTBAGc6ZZ427FI9WXZakRuI=";
          cp312 = "sha256-PnKHZmINbjEYajepBsB7gH2i86rPSxZ/bos3xy7U3mM=";
        };
        x86_64-darwin = {
          cp39 = "aa5692cc8f584c5f531074fd7283004acfbc538b36101f6c403d4ff1837aca52";
          cp310 = "515bc5d9811cc4bb982daf6c7b2c82453cccc886e41514e03bc3342293acb109";
          cp311 = "6e2b8ad794729f068742ffc2547fd322fa6ef31e46e886ac6e53690b86415cf0";
          cp312 = "6b117e01d0304305e459cccc78e1b46dc1ee60227a2afd8569d97b7a2bc516ed";
        };
        x86_64-linux = {
          cp39 = "sha256-rGz4bKRemxRdHCLPpHBpzdyq3ms/3Bsd5adhEJfZbX4=";
          cp310 = "sha256-i+C9U2ErZEbDm09OnLS9NUhknVISR3NJzPvcklCHgik=";
          cp311 = "sha256-6JJLbtCGZVsr+LP/KaxFPR6Kp6TW0s6WW7ql+xfRNk8=";
          cp312 = "sha256-4+3gNnqyj72GiiL05M2sRFQ8ZU4svFo7SCF45/cl6iw=";
        };
      };
    in
    fetchPypi {
      inherit pname version format;
      dist = pyShortVersion;
      python = pyShortVersion;
      abi = pyShortVersion;
      platform = platforms.${stdenv.hostPlatform.system} or { };
      sha256 = hashes.${stdenv.hostPlatform.system}.${pyShortVersion} or { };
    };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  dependencies = [
    click
    aiosignal
    filelock
    frozenlist
    jsonschema
    msgpack
    packaging
    protobuf
    pyyaml
    requests
    watchfiles
  ];

  optional-dependencies = rec {
    adag = cgraph;
    air = lib.unique (data ++ serve ++ tune ++ train);
    all = lib.flatten (builtins.attrValues optional-dependencies);
    cgraph = [
      cupy
    ];
    client = [ grpcio ];
    data = [
      fsspec
      numpy
      pandas
      pyarrow
    ];
    default = [
      aiohttp
      aiohttp-cors
      colorful
      grpcio
      opencensus
      prometheus-client
      pydantic
      py-spy
      requests
      smart-open
      virtualenv
    ];
    observability = [
      memray
      opentelemetry-api
      opentelemetry-sdk
      opentelemetry-exporter-otlp
    ];
    rllib = [
      dm-tree
      gymnasium
      lz4
      # ormsgpack
      pyyaml
      scipy
      typer
      rich
    ];
    serve = lib.unique (
      [
        fastapi
        requests
        starlette
        uvicorn
        watchfiles
      ]
      ++ default
    );
    serve-grpc = lib.unique (
      [
        grpcio
        pyopenssl
      ]
      ++ serve
    );
    train = tune;
    tune = [
      fsspec
      pandas
      pyarrow
      requests
      tensorboardx
    ];
  };

  postInstall = ''
    chmod +x $out/${python.sitePackages}/ray/core/src/ray/{gcs/gcs_server,raylet/raylet}
  '';

  pythonImportsCheck = [ "ray" ];

  meta = {
    description = "Unified framework for scaling AI and Python applications";
    homepage = "https://github.com/ray-project/ray";
    changelog = "https://github.com/ray-project/ray/releases/tag/ray-${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ billhuang ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
