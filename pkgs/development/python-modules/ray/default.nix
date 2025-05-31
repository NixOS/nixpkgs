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
  version = "2.46.0";
in
buildPythonPackage rec {
  inherit pname version;
  format = "wheel";

  disabled = pythonOlder "3.9" || pythonAtLeast "3.14";

  src =
    let
      pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
      platforms = {
        aarch64-darwin = "macosx_11_0_arm64";
        aarch64-linux = "manylinux2014_aarch64";
        x86_64-darwin = "macosx_10_15_x86_64";
        x86_64-linux = "manylinux2014_x86_64";
      };
      # ./pkgs/development/python-modules/ray/prefetch.sh
      # Results are in ./ray-hashes.nix
      hashes = {
        x86_64-linux = {
          cp310 = "sha256-wShQYIxXyK/ZYTqfdX13ZjxQ1L1Od7ovGBQlBSUgwBo=";
          cp311 = "sha256-1N3tw/TUjfVkvO57ExyYyfiY/vCldIP0ujNfR/lRpi8=";
          cp312 = "sha256-XOwe3ak/YY/9IwH4HVOYA38D+psWgl5+TYoArnqaQ4E=";
          cp313 = "sha256-paKMCjEdLDIh3PcpxAiYpt+CRmu1ryHoG+BFPgmFat8=";
        };
        aarch64-linux = {
          cp310 = "sha256-OWuRKk2/ZJZuL9/Kn6y8r+V7eSykhCrFrhdQf9vf6J8=";
          cp311 = "sha256-gcjOi3ujPLYH7Hj16yVVRw4wRrsxdzLYKC6BibtYzL0=";
          cp312 = "sha256-AGy+Go/cN2ZBFKohh3MQDuiROZeF4lbCAuSJWNLawWc=";
          cp313 = "sha256-gI2uzh8SvYkkucY4Kg+Y2m9caIbPsnHtjYlAeolBPNU=";
        };
        x86_64-darwin = {
          cp310 = "sha256-cZJEuE33lQLl8JSX8lZhjZTXjWb7ryKUIgCKBWjToP8=";
          cp311 = "sha256-lCulHeb5zX+y7RdhgYGvSM5rlRd0PTI12EbsMileynY=";
          cp312 = "sha256-0fN+rSkpljcURyb4CcLg/5WN2cDnWTDvYUFW1qCjpX8=";
          cp313 = "sha256-svwsQ+oKN1IRk8Ye+aJ7b8qNurEWpYpS/UQ0TNc+Hs4=";
        };
        aarch64-darwin = {
          cp310 = "sha256-Q3ioaRnmZDI4oQlPcRuH+o3BoYuZjUGQ9pqzPGSiKow=";
          cp311 = "sha256-r4Tz7QhUu23igZLKngo7+h6zTWnxGK5jSFIhmIlkgMg=";
          cp312 = "sha256-t6BkrP7ufwZ32ePyXa75xZWTVZ+up2S0Sj4sUzHV2DI=";
          cp313 = "sha256-QpbdjAF0JWoE7ktUq+ATtoAqRfuF+3z9sTdSMZZdbU0=";
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
