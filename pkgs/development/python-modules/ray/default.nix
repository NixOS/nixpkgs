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
  version = "2.43.0";
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
        x86_64-linux = {
          cp39 = "sha256-Xt89oYBB4LYXDGLghICrBQ8HZjYf8/bhElfMBKtG5ZI=";
          cp310 = "sha256-GHKYOihahbd2vzEcgJ1Vn4SCkJotOerV8qxpz+OqhUQ=";
          cp311 = "sha256-eMO9vxgrTQGfqaiqvVXDm/cFu2MK6gZPdo8wX8Ry0es=";
          cp312 = "sha256-tF9HjSnOXfP8GYYd9k/vntXCXx6D+hACjTP63v3soJU=";
        };
        aarch64-linux = {
          cp39 = "sha256-h+DKyFGJ3FGa8bbvKr1lSATEiMkyyq3WWLkMqqZfja4=";
          cp310 = "sha256-VzgcVPIA5sAgPV9wrG+IKxPMGoD68zZRh4ejmm1vZdA=";
          cp311 = "sha256-R27D4fokZN3V8EnA8nWP+d/swh+430Jm8d8BsngMZlM=";
          cp312 = "sha256-c3cNTIqYlzCYX/K0KSEpJJ4oweKehFiUcMm6GukcqDI=";
        };
        x86_64-darwin = {
          cp39 = "sha256-0OJvnbkaWzND8IWOslYlWzXH6X/Gv5cGX1dErX6Mwpc=";
          cp310 = "sha256-GGJv/zaEUaN6drM9UqcPBbIKIR6whn2GByHI6Gy2lVo=";
          cp311 = "sha256-/eioEoDwevmDvDdpyZQdtdsnPOEOkquzNI5BvtAj1zU=";
          cp312 = "sha256-USH99Ly8sP2jubcRZN1sj8x5ouJYAioqOVfkAQGJE/s=";
        };
        aarch64-darwin = {
          cp39 = "sha256-2M/ewr9hxIaQ9stDJfFnPg0dAN6pJbWbYxGW5n9Cag4=";
          cp310 = "sha256-t8T97FmhTWspOdkf7m78hLYUpnIsO+Cyf6Nx4/VjJV8=";
          cp311 = "sha256-6TwyrQy2fx99p2+sQJ2H1c1eo+sDuDaDDp71zIELwsA=";
          cp312 = "sha256-fyb3ty2gTDxEIiacMbBnq9Fcs4QktwEtgS3fssd0Yuo=";
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
