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
  click,
  filelock,
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
  version = "2.49.0";
in
buildPythonPackage rec {
  inherit pname version;
  format = "wheel";

  disabled = pythonOlder "3.9" || pythonAtLeast "3.14";

  src =
    let
      pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
      platforms = {
        aarch64-darwin = "macosx_12_0_arm64";
        aarch64-linux = "manylinux2014_aarch64";
        x86_64-darwin = "macosx_12_0_x86_64";
        x86_64-linux = "manylinux2014_x86_64";
      };
      # ./pkgs/development/python-modules/ray/prefetch.sh
      # Results are in ./ray-hashes.nix
      hashes = {
        x86_64-linux = {
          cp310 = "sha256-bFQKbfqOWC4HJQV8E3JFzNP6DWl7R2SFMxdvWoqzCjA=";
          cp311 = "sha256-Ja5MII3Hi0plPDEcsmuTx0QB5nYqGTztX6uqkQqBfYE=";
          cp312 = "sha256-lShdI6MDsXTQcKaz6ocj6dq/B6QUegHLkzHV6t+MoLI=";
          cp313 = "sha256-42mZ1Pgx8vIcqPtWnwWY+4DKjawPiDbErHXM2ltVi/s=";
        };
        aarch64-linux = {
          cp310 = "sha256-jFWnpGKgzese1Y+jYQ9S46KEzk4MVVZjWb0RWKloP0Q=";
          cp311 = "sha256-KnXS/YvKsahQkeow5ZMsXiiXxxIq4j+SH0+v7sIsOCg=";
          cp312 = "sha256-NjVn9WES86FRjs2NDjoM5PBTcFzI9NQ+kzyvafs1lxw=";
          cp313 = "sha256-/Wu+DBhvHWpJ31NTKyGSH9Bf+ZPLVG9mW3GAmGIPY8U=";
        };
        x86_64-darwin = {
          cp310 = "sha256-6Qjm97RkKdJvRZRXlFgpiETRpIXCiM/liRT6eilP06Q=";
          cp311 = "sha256-5CpBh6kOiXr7lVF8uKpPwMJHGL1Ci97AsmCqLRjs5sg=";
          cp312 = "sha256-FvsQ5YuuSDECZ16Cnq0afQpHjcVfmf8GuDKnicogi6k=";
          cp313 = "sha256-LhOphUj78ujX8JY8YK/1HZtT01naDO9QoHGpUMT85Uo=";
        };
        aarch64-darwin = {
          cp310 = "sha256-seRUvxTQCGfaXslF4L4IfWhFfyQbqmClDLccBBosTfw=";
          cp311 = "sha256-VKipsP5qnLFagvNxwufWhCD540/+OKi+PD3UvlQFHGY=";
          cp312 = "sha256-+UOpwq4EljaxJqGUBH/fkQEGCpmF0dthSxeycGH46fM=";
          cp313 = "sha256-9CDvy2n6ZDAf8su3YR10rwEguu6OhAhtjzuV6BVTD5M=";
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
    filelock
    jsonschema
    msgpack
    packaging
    protobuf
    pyyaml
    requests
    watchfiles
  ];

  optional-dependencies = lib.fix (self: {
    adag = self.cgraph;
    air = lib.unique (self.data ++ self.serve ++ self.tune ++ self.train);
    all = lib.unique (
      self.adag
      ++ self.air
      ++ self.cgraph
      ++ self.client
      ++ self.data
      ++ self.default
      ++ self.observability
      ++ self.rllib
      ++ self.serve
      ++ self.train
      ++ self.tune
    );
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
      ++ self.default
    );
    serve-grpc = lib.unique (
      [
        grpcio
        pyopenssl
      ]
      ++ self.serve
    );
    train = self.tune;
    tune = [
      fsspec
      pandas
      pyarrow
      requests
      tensorboardx
    ];
  });

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
