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
  version = "2.51.0";
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
        x86_64-linux = "manylinux2014_x86_64";
      };
      # ./pkgs/development/python-modules/ray/prefetch.sh
      # Results are in ./ray-hashes.nix
      hashes = {
        x86_64-linux = {
          cp310 = "sha256-Ag3Ynx7RHTOM75BhdGsatc8mNpDBkiQi4zPsdC8Cvpc=";
          cp311 = "sha256-EYXBn2iHyik5DC+EQTD3LDOX1XNZRxX5paZN7PuyGUI=";
          cp312 = "sha256-cLfLCsRVoZbIIRMkQAzy93c60NXwWF0htiVZ6aADOAk=";
          cp313 = "sha256-yCsJhLPRDYhNI69cpK3oqjdoyVfMtDJwSvjpIOXN4y0=";
        };
        aarch64-linux = {
          cp310 = "sha256-48d59JxV5tth4iylLuET+Apo5APafNbaDoSAyuZi9QM=";
          cp311 = "sha256-2Z31lVJ3rK4YasnGzux39Lp2Lw8hNaP3AVd3cYeu7T0=";
          cp312 = "sha256-BHFnYv5SJOp9Dp25w5ZhBLGyrsyr/MhQhRAtdPAzShE=";
          cp313 = "sha256-PfIB7kmN8ZCAN6N5VK33C77Id6gdPWD/Lcj0LIlh530=";
        };
        aarch64-darwin = {
          cp310 = "sha256-olwAGedusCeQeyi4y77LYteoYX55/0dcHWURYq/a/O0=";
          cp311 = "sha256-eTY8nQJzJVEw81ncGJuhpye7mCiudzUxQ35WryCsaxw=";
          cp312 = "sha256-BfktgeYrADF5pXwrMo3alloboyXdtSJWZVmapLUew6U=";
          cp313 = "sha256-cRGOKyOm0t8hQoauqDEXU80+y6CNPApjGl8gsc8lJg0=";
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
    changelog = "https://github.com/ray-project/ray/releases/tag/ray-${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ billhuang ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
