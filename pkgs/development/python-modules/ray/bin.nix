{ aiohttp
, aiohttp-cors
, aiorwlock
, aiosignal
, attrs
, autoPatchelfHook
, buildBazelPackage
, buildPythonPackage
, fetchPypi
, click
, cloudpickle
, colorama
, colorful
, cython
, dm-tree
, fastapi
, fetchFromGitHub
, filelock
, frozenlist
, fsspec
, grpcio
, gym
, jsonschema
, lib
, lz4
, matplotlib
, msgpack
, numpy
, opencensus
, packaging
, pandas
, py-spy
, prometheus-client
, protobuf
, psutil
, pyarrow
, pydantic
, python
, pythonRelaxDepsHook
, pyyaml
, requests
, scikitimage
, scipy
, setproctitle
, smart-open
, starlette
, stdenv
, tabulate
, tensorboardx
, uvicorn
, virtualenv

  # optional dependencies
, withData ? true
, withServe ? true
, withTune ? true
  # rllib is tune with extra dependencies
, withRllib ? true
  # air is tune + data + train + serve
, withAir ? true
}:

# this binary version is needed because:
# - the source build is missing the dashboard.
# - the source build does not enable pytest, so it may have some issues.

let
  pname = "ray";
  version = "2.0.0";
  pyShortVersion = "cp${builtins.replaceStrings ["."] [""] python.pythonVersion}";
  unsupported = throw "Unsupported system";
  binary-hash = (import ./binary-hashes.nix)."${pyShortVersion}" or unsupported;
in
buildPythonPackage rec {
  inherit pname version;
  format = "wheel";
  src = fetchPypi ({
    inherit pname version format;
    dist = pyShortVersion;
    python = pyShortVersion;
    abi = pyShortVersion;
    platform = "manylinux2014_x86_64";
  } // binary-hash);

  nativeBuildInputs = [
    autoPatchelfHook
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "grpcio" "click" ];

  data-deps = [
    pandas
    pyarrow
    fsspec
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

  rllib-deps = tune-deps ++ [
    dm-tree
    gym
    lz4
    matplotlib
    scikitimage
    pyyaml
    scipy
  ];

  air-deps = data-deps ++ serve-deps ++ tune-deps ++ rllib-deps;

  propagatedBuildInputs = [
    attrs
    aiohttp
    aiohttp-cors
    aiosignal
    click
    cloudpickle
    colorama
    colorful
    cython
    filelock
    frozenlist
    grpcio
    jsonschema
    msgpack
    numpy
    opencensus
    packaging
    py-spy
    prometheus-client
    protobuf
    psutil
    pydantic
    pyyaml
    requests
    setproctitle
    smart-open
    virtualenv
  ] ++ lib.optionals withData data-deps
  ++ lib.optionals withServe serve-deps
  ++ lib.optionals withTune tune-deps
  ++ lib.optionals withRllib rllib-deps
  ++ lib.optionals withAir air-deps;

  pythonImportsCheck = [ "ray" ];

  meta = with lib; {
    description = "A unified framework for scaling AI and Python applications";
    homepage = "https://github.com/ray-project/ray";
    license = licenses.asl20;
    maintainers = with maintainers; [ billhuang ];
    platforms = [ "x86_64-linux" ];
  };
}
