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
  version = "2.41.0";
in
buildPythonPackage rec {
  inherit pname version;
  format = "wheel";

  disabled = pythonOlder "3.9" || pythonAtLeast "3.13";

  src =
    let
      pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
      platforms = {
        aarch64-linux = "manylinux2014_aarch64";
        x86_64-linux = "manylinux2014_x86_64";
      };
      # hashes retrieved via the following command
      # curl https://pypi.org/pypi/ray/${version}/json | jq -r '.urls[] | "\(.digests.sha256)  \(.filename)"'
      hashes = {
        aarch64-linux = {
          cp39 = "782f29c8d743304fb3b67ed825db6caf5e5bd9263d628a6ff67a61bccde9f176";
          cp310 = "fbb2cf4a86f4705faea6334356faa4dc7f454210e6eb085d63b7f1ae6e9c12e1";
          cp311 = "68c9cc50af0dfafa78e5047890018cf3115fae8702ab083ac78b59b349989d45";
          cp312 = "c9712ee4c52b7764b2ec9c693419ffde1313dd79cb186173dae6e25db44993de";
        };
        x86_64-linux = {
          cp39 = "fe837e717a642a648f6fa8cc285e3ccc6782d126b8af793a25903fa3ac8d5c22";
          cp310 = "3932d6db3a8982c5196db08cf56e2ed0bf50b8568508cfe486be8de63ba2d95d";
          cp311 = "fff5e9cc5a53815d3b586a261e34bd0fef1c324b2cded4c9b8e790e1e3dc3997";
          cp312 = "3d76acb070fa8bd4ebdb011acdfa22bb89bdbe9b35fb78aec5981db76eac2b60";
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

  nativeBuildInputs = [
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
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
