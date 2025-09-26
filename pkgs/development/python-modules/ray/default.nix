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
  version = "2.49.2";
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
          cp310 = "sha256-dFZodq979OSOpLmzt1s02wU9EGTMTUsWcNxM549olK8=";
          cp311 = "sha256-VAd93jOMX/ujSaSrYbcjUqPDvmnqW08bQ22Y1AsxJ2M=";
          cp312 = "sha256-LsqqUfWIzN2ithVjqL44Q79l36qoOiQFiKMH9Ou4JHE=";
          cp313 = "sha256-t9ghTP+G3wRP7HJ+7qvMw7/JsCcdKNYbqSwJ8NEn0B0=";
        };
        aarch64-linux = {
          cp310 = "sha256-6uB7P+1F9bBBqL+Xlc0m+tJGS+USbv1EfkSEkFoptnc=";
          cp311 = "sha256-6tqd2JzNpkOjxsLLpwFrWYmEMtEm4Qs4/tUtdBZTZPQ=";
          cp312 = "sha256-3Q2NhkHRQvr+bYPofTwZvVY30h40YI0/9prXHqPi9GI=";
          cp313 = "sha256-tMeGlojFGOkC97Yojt7CNlq00opGQpHm0KcEDH0Btfc=";
        };
        x86_64-darwin = {
          cp310 = "sha256-PkQb8qzX82jPRRMnUgZsXDuD2IzV+Fdi5wN3S7pPK20=";
          cp311 = "sha256-ns6VehOYX3u/QHf0/wIEMU1+malB+V3/Kha0U9U3bcM=";
          cp312 = "sha256-Z4TgduRBgiLvjuO2qL/rhn2Hl4A7Jbz8zjvzvFQUvvE=";
          cp313 = "sha256-svTw/tk2+vaI6H/9zJNWwDRRPAAlmi8ahYnjRfz728A=";
        };
        aarch64-darwin = {
          cp310 = "sha256-CL7EZ1drwDDYvQY4AE4bjgdViJKTSREpiKS9SShoTow=";
          cp311 = "sha256-T7n5v2L9XJLSLaIM0qrLSt4fsjAzdl+pJ08KDFC8QvY=";
          cp312 = "sha256-1tYS3lxjQbd2/HXt7uW2mLtK9+6Eov8wVSsyqebkp3I=";
          cp313 = "sha256-Li/iD6kFYuc2MNqf95MtPtZQfnMpHE2b31ZlN66d7d8=";
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
