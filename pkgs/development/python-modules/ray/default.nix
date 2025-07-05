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
  version = "2.47.1";
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
        x86_64-darwin = "macosx_12_0_x86_64";
        x86_64-linux = "manylinux2014_x86_64";
      };
      # ./pkgs/development/python-modules/ray/prefetch.sh
      # Results are in ./ray-hashes.nix
      hashes = {
        x86_64-linux = {
          cp310 = "sha256-hKlrRyAXWgAAUhpI63qpFfO0Gbtc1hctje4AXD8juBM=";
          cp311 = "sha256-SJYSKWFLK1alNb5RDIq8dumamqf6GVtclJvQxsaa9Ao=";
          cp312 = "sha256-Pq6u7Du+LKZJPlMMMEc9hLhYCnrDJWu5GD2MY971qS8=";
          cp313 = "sha256-JSpHHor7kYsQXNv/tMvrsBQ7qtdaBsj/zeJ6wxdXnMs=";
        };
        aarch64-linux = {
          cp310 = "sha256-b8ffhle432hLd8LRtkMTetdFqhwSreNHQ/BsynkAPfA=";
          cp311 = "sha256-21/2UukDXwPGXhdCpwa3ZRn26KZ0TMAFOWBTrIdm/EY=";
          cp312 = "sha256-zU5+tHVIc2S1IJljsXzv7ct/vTqBb9tt736lM+vXJCQ=";
          cp313 = "sha256-1u1tGC4l1vdxedx3vJenScgXZbE8tnGkbbMgMCk4lmM=";
        };
        x86_64-darwin = {
          cp310 = "sha256-fAOh42bTqGilX4wvco9c41rIXd8JOsgdDBo1vxwlw3c=";
          cp311 = "sha256-/uuh5xXP2HN9OtzSAY0M2rt8YIT6Swk+Y45sfULzyVY=";
          cp312 = "sha256-5tnHjlOsicq7xAVq7P7FPFBsaS4xMq+drpQdYYDvRi8=";
          cp313 = "sha256-5XiSn1iz8MWcdUSpbYZOJieCOLdV0TzRmueYBwyEjlc=";
        };
        aarch64-darwin = {
          cp310 = "sha256-NqMJMOjSZecI35bzf28fVIT0uXCQ1QWRL5kuBFpp0xA=";
          cp311 = "sha256-pkDUR+Dmz2P4W5IgyIPsArsrjkCpwdhO+gEnlcdpumg=";
          cp312 = "sha256-MiBJxFRs9n5e/a2Qw3HFUIrLsZPlqq9AOBA8bFzh9Xg=";
          cp313 = "sha256-jNYl1GnOFTkeXx9E3fjdMLI4D5F2A/oBcmYSKaywAR8=";
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
