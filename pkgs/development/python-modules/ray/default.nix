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
  version = "2.49.1";
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
          cp310 = "sha256-k4TScFnK+Go4y7y0Iqthto3oczN4S/GyJyLXT9ugHvY=";
          cp311 = "sha256-yKA5RHwwSeM226+f8WcylDr/i959U3Y5C8W3HrCMuZY=";
          cp312 = "sha256-SEBk/KAnMuC29KCdrQ0ftqvUykttm/fCareheiiHzQk=";
          cp313 = "sha256-147zp65IgZ1kD8BQBr8qfKq0ixXFZ6U6ecAV89AFSz0=";
        };
        aarch64-linux = {
          cp310 = "sha256-jzmr4eTqXk3eJWfn5697QffrU/apw9PRy4APt6NlIQQ=";
          cp311 = "sha256-y2/eQS5jT5MzPGRrEInk0xhLx/y3/AKBiJGygagCQNI=";
          cp312 = "sha256-z2O5FuOZwqTUhCSWEals7ig87zLlRBJhFaStPocsNOs=";
          cp313 = "sha256-lOHFBoiXxjVG0J6iY6iETOFjxtgM4wsa863HU3CL5jw=";
        };
        x86_64-darwin = {
          cp310 = "sha256-mQhrS7MgOL1jt1dWZ/3BQly3Ua/gQ07Q0Vjj0+4Mcm8=";
          cp311 = "sha256-Wx4ACGFWodWJZk0ezOPUWJsInLqwnXuHgDYOWzSukHo=";
          cp312 = "sha256-+TZd46mmYczwid+qwByLaLoAyYRDMw72eODAJIJyxyI=";
          cp313 = "sha256-D7LijIDkWZ/+w6NOkmubASrRw1D0nNuNiJLderk7R4k=";
        };
        aarch64-darwin = {
          cp310 = "sha256-+OEt19uCFahu9xg6LJwiECiA4OzQj5Sx0XrZ5gfko1k=";
          cp311 = "sha256-lDJtsMg/fzkTUrE1s3qOynN8Gt3xiQKrGQvmuGCKgDk=";
          cp312 = "sha256-96cVhV0XnB3Wri6LX4kZY4zeN5pbFXljoL100ReLi1o=";
          cp313 = "sha256-XRnlaKjPvM8Si/NPnOSLy9EenwuU2xkEBPa+tVrkldI=";
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
