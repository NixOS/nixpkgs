{
  lib,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
  python,
  fetchPypi,
  autoPatchelfHook,

  # dependencies
  aiohttp,
  aiohttp-cors,
  aiosignal,
  attrs,
  click,
  cloudpickle,
  colorama,
  colorful,
  cython,
  filelock,
  frozenlist,
  gpustat,
  grpcio,
  jsonschema,
  msgpack,
  numpy,
  opencensus,
  packaging,
  prometheus-client,
  psutil,
  pydantic,
  py-spy,
  pyyaml,
  requests,
  setproctitle,
  smart-open,
  virtualenv,

  # optional-dependencies
  fsspec,
  pandas,
  pyarrow,
  dm-tree,
  gym,
  lz4,
  matplotlib,
  scikit-image,
  scipy,
  aiorwlock,
  fastapi,
  starlette,
  uvicorn,
  tabulate,
  tensorboardx,
}:

let
  pname = "ray";
  version = "2.37.0";
in
buildPythonPackage rec {
  inherit pname version;
  format = "wheel";

  disabled = pythonOlder "3.10" || pythonAtLeast "3.13";

  src =
    let
      pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
      binary-hash = (import ./binary-hashes.nix)."${pyShortVersion}" or { };
    in
    fetchPypi (
      {
        inherit pname version format;
        dist = pyShortVersion;
        python = pyShortVersion;
        abi = pyShortVersion;
        platform = "manylinux2014_x86_64";
      }
      // binary-hash
    );

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  pythonRelaxDeps = [
    "click"
    "grpcio"
    "protobuf"
    "virtualenv"
  ];

  dependencies = [
    aiohttp
    aiohttp-cors
    aiosignal
    attrs
    click
    cloudpickle
    colorama
    colorful
    cython
    filelock
    frozenlist
    gpustat
    grpcio
    jsonschema
    msgpack
    numpy
    opencensus
    packaging
    prometheus-client
    psutil
    pydantic
    py-spy
    pyyaml
    requests
    setproctitle
    smart-open
    virtualenv
  ];

  optional-dependencies = rec {
    air-deps = data-deps ++ serve-deps ++ tune-deps ++ rllib-deps;
    data-deps = [
      fsspec
      pandas
      pyarrow
    ];
    rllib-deps = tune-deps ++ [
      dm-tree
      gym
      lz4
      matplotlib
      pyyaml
      scikit-image
      scipy
    ];
    serve-deps = [
      aiorwlock
      fastapi
      pandas
      starlette
      uvicorn
    ];
    tune-deps = [
      tabulate
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
    platforms = [ "x86_64-linux" ];
  };
}
