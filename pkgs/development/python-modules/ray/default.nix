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
  version = "2.50.0";
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
          cp310 = "sha256-yDG/+6D28N+iW2XFuAACLHI0y+wbmKjt4X+XzIJfcA0=";
          cp311 = "sha256-A7Zfzo7eJuKlI2XyCWfAmzo16dfSuFZkXcxoBDWkfkM=";
          cp312 = "sha256-IUoAZIlBnHhnFcsqgbPFLIjgjqMpX0i6l6tpuIjY+Bg=";
          cp313 = "sha256-g40spgZcElW2xw8dIEHKC2qzq6uQgzA7ZdezE4wCLeI=";
        };
        aarch64-linux = {
          cp310 = "sha256-AGKn+lY/QkZlsc3sD+6ccHCNqAfsxZFsSZJaIUOIl9A=";
          cp311 = "sha256-sTkjnzAUDpgve8X7HMJpSKCnbJgOujce/d4/sEXQp+Q=";
          cp312 = "sha256-z94CocsRRIF1ir/kC0uMMa/hmRUIhzciUUZiVnVpEcs=";
          cp313 = "sha256-E1xwySvTwwUEQckFV26HG4edykhmSSGMRSQaPsRXI5k=";
        };
        aarch64-darwin = {
          cp310 = "sha256-sWTWr0IMejioMj+P83iLjFfO9GebNIg1ShI3GqwBh04=";
          cp311 = "sha256-YZsua4gNWvEm3x382qJzFO3UPSxtYxXgHR4xGDmr/+Q=";
          cp312 = "sha256-5oOYG1H/U0wJpIs6W2X8YYht49qKroc4I5WR2rK2fOU=";
          cp313 = "sha256-w9qWaV4/Y70O7K1tMOx89tAwmoc44xrCcJV4ErzBzYs=";
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
      "x86_64-linux"
    ];
  };
}
