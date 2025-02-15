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
  version = "2.42.1";
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
          cp39 = "sha256-MijkhGUC4MW+rmm2mfyQcaBtPPv8DKXyvScHkkpS40s=";
          cp310 = "sha256-YHJ/nHKo9xvE4U1H3E3ElNxZo8Sw0QiuBPpuWo5FIo8=";
          cp311 = "sha256-8BlRTFIgqCL7wMOO0fdQXOx1uWGnYEq2d/1kd+M6Ki4";
          cp312 = "sha256-orb2JZC7YF1m043rSV84MqbQMB2z9JatxU0SoURUHjc=";
        };
        aarch64-linux = {
          cp39 = "sha256-V/epiChYGASp537Jnz/d1UIl2r2pwNmmdx630i5pMHI=";
          cp310 = "sha256-kNi/DBr+I2SjP1NWNnYaV0440oOwQGE7joY5vhQdBKA=";
          cp311 = "sha256-xdeeSYrOtapbPlMH7HSV9YSGtCZrOP7qOXm5iB6VDE8=";
          cp312 = "sha256-nKXH/V9nboMXgS53AY9i+HxbOa4Op/n4DW6YzSL99Vo=";
        };
        x86_64-darwin = {
          cp39 = "sha256-EgWa4hgQ0K6LCcx8N51SzRCIgbi56cYo0ywEWXD8KsQ=";
          cp310 = "sha256-ufLyDLLd31LsB+JU84upFGe4bfETMImdauI2GD45UnU=";
          cp311 = "sha256-ToHIlnedis5mr8KsdQUIBtsQLZUBou1uovOAEJYsyn8=";
          cp312 = "sha256-t+9IkWQyoNXMyr78jL2L8MDSrQuIQczjzr0bEzmWyjY=";
        };
        x86_64-linux = {
          cp39 = "sha256-LUATaRjN1/YHEKpGRS7vqcDkYOLE51svxXI8c9521wE=";
          cp310 = "sha256-AYAiSeuc02Mm5v4LqoiRb6YGJzHaElBryT5zbxcRHdQ=";
          cp311 = "sha256-z1vEMnUuKbyADjAAO9ZJM9eFND9ZqajDGoOc2YH8UIQ=";
          cp312 = "sha256-4Np/+6ctOsJ1B4FvAPKtM0+BWDX0e4sEghzFdQ7Flkc=";
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
