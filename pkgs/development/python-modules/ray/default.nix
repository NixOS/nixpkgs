{
  lib,
  stdenv,
  buildPythonPackage,
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
  opentelemetry-exporter-prometheus,
  opentelemetry-proto,
  opentelemetry-sdk,
  prometheus-client,
  pydantic,
  py-spy,
  smart-open,
  virtualenv,
  # llm
  async-timeout,
  hf-transfer,
  jsonref,
  meson,
  ninja,
  # nixl,
  pybind11,
  typer,
  vllm,
  # observability
  memray,
  # rllib
  dm-tree,
  gymnasium,
  lz4,
  ormsgpack,
  scipy,
  # serve
  fastapi,
  starlette,
  uvicorn,
  watchfiles,
  # serve-async-inference
  celery,
  # serve-grpc
  pyopenssl,
  # tune
  tensorboardx,
}:

buildPythonPackage (finalAttrs: {
  pname = "ray";
  version = "2.55.1";
  format = "wheel";
  __structuredAttres = true;

  disabled = pythonAtLeast "3.15";

  src =
    let
      pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
      platforms = {
        aarch64-darwin = "macosx_12_0_arm64";
        aarch64-linux = "manylinux2014_aarch64";
        x86_64-linux = "manylinux2014_x86_64";
      };
      # ./pkgs/development/python-modules/ray/prefetch.sh
      # Results are in ./ray-hashes.nix
      hashes = {
        x86_64-linux = {
          cp311 = "sha256-1TgtoYHAPuL1Au9Gzwrku8MBV7W9mmfXZR9qJyUoqFo=";
          cp312 = "sha256-JjcF9rqynnYiqU+C2iX9f5zq12zfiaB6qyj3nN+PnZU=";
          cp313 = "sha256-E4DgQ+tXzeabfpGZxvJVjO648PxByX0dXlDqBCEV8wI=";
          cp314 = "sha256-FW7T5yrZW2RdIAbNcajd28yJtWv8AAJ/YiWt94vZy3Q=";
        };
        aarch64-linux = {
          cp311 = "sha256-DqL2cKdyWDOtIzOoxGq2mGWtBsjl3p9laV4PjzUzHOw=";
          cp312 = "sha256-JlQfabtVYH74M1uqx1su0S/yzgLVYxMhmyntoAMDkiE=";
          cp313 = "sha256-tBXVkOBi8kiQfg/kKZSUPxFya3F4/PSxz1VGch+xpfg=";
          cp314 = "sha256-TmGNYeGxS2/emlhhUfP9nUNbC4UEi5l7yqf0pTN0eys=";
        };
        aarch64-darwin = {
          cp311 = "sha256-AFP9W0APesViY6obvT1o+3k0Gwi43Gl8iHgtWsp7PtQ=";
          cp312 = "sha256-E3+QBu7ijKq4JggDzKMU83u9o/yU/foxx3C10Bliatg=";
          cp313 = "sha256-+YRKknLvLm61dxAlhmByz0I0z0x8waMeI1t95xEYZL4=";
          cp314 = "sha256-sGIEXGTCvOOaUWYWJPcpLHu/MPKp2Hhieq4x1G2lcS0=";
        };
      };
    in
    fetchPypi {
      inherit (finalAttrs) pname version;
      format = "wheel";
      dist = pyShortVersion;
      python = pyShortVersion;
      abi = pyShortVersion;
      platform = platforms.${stdenv.hostPlatform.system} or { };
      sha256 =
        hashes.${stdenv.hostPlatform.system}.${pyShortVersion}
          or (throw "No hash specified for '${stdenv.hostPlatform.system}.${pyShortVersion}'");
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
      ++ self.serve-async-inference
      ++ self.serve-grpc
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
      opentelemetry-exporter-prometheus
      opentelemetry-proto
      opentelemetry-sdk
      prometheus-client
      pydantic
      py-spy
      requests
      smart-open
      virtualenv
    ];
    llm = lib.unique (
      [
        async-timeout
        hf-transfer
        jsonref
        jsonschema
        meson
        ninja
        # nixl
        pybind11
        typer
        vllm
      ]
      ++ self.data
      ++ self.serve
      ++ vllm.optional-dependencies.audio
    );
    observability = [
      memray
    ];
    rllib = lib.unique (
      [
        dm-tree
        gymnasium
        lz4
        ormsgpack
        pyyaml
        scipy
      ]
      ++ self.tune
    );
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
    serve-async-inference = lib.unique (
      [
        celery
      ]
      ++ self.serve
    );
    serve-grpc = lib.unique (
      [
        grpcio
        pyopenssl
      ]
      ++ self.serve
    );
    train = lib.unique (
      [
        pydantic
      ]
      ++ self.tune
    );
    tune = [
      fsspec
      pandas
      pyarrow
      requests
      tensorboardx

      # `import ray.tune` fails without pydantic
      # Reported upstream: https://github.com/ray-project/ray/issues/58280
      pydantic
    ];
  });

  postInstall = ''
    chmod +x $out/${python.sitePackages}/ray/core/src/ray/{gcs/gcs_server,raylet/raylet}
  '';

  pythonImportsCheck = [ "ray" ];

  meta = {
    description = "Unified framework for scaling AI and Python applications";
    homepage = "https://github.com/ray-project/ray";
    changelog = "https://github.com/ray-project/ray/releases/tag/ray-${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ billhuang ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
