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
, filelock
, frozenlist
, fsspec
, gpustat
, grpc
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
, protobuf3_20
, psutil
, pyarrow
, pydantic
, python
, pythonAtLeast
, pythonOlder
, pythonRelaxDepsHook
, pyyaml
, redis
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
}:

let
  pname = "ray";
  version = "2.0.0";
in
buildPythonPackage rec {
  inherit pname version;
  format = "wheel";

  disabled = pythonOlder "3.8" || pythonAtLeast "3.11";

  src =
    let
      pyShortVersion = "cp${builtins.replaceStrings ["."] [""] python.pythonVersion}";
      binary-hash = (import ./binary-hashes.nix)."${pyShortVersion}";
    in
    fetchPypi ({
      inherit pname version format;
      dist = pyShortVersion;
      python = pyShortVersion;
      abi = pyShortVersion;
      platform = "manylinux2014_x86_64";
    } // binary-hash);

  passthru.optional-dependencies = rec {
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
  };

  nativeBuildInputs = [
    autoPatchelfHook
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "grpcio" "click" "protobuf" ];

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
    gpustat
    grpcio
    jsonschema
    msgpack
    numpy
    opencensus
    packaging
    py-spy
    prometheus-client
    protobuf3_20
    psutil
    pydantic
    pyyaml
    requests
    setproctitle
    smart-open
    virtualenv
  ];

  postInstall = ''
    chmod +x $out/${python.sitePackages}/ray/core/src/ray/{gcs/gcs_server,raylet/raylet}
    ln -sf ${redis}/bin/redis-server $out/${python.sitePackages}/ray/core/src/ray/thirdparty/redis/src/redis-server
  '';

  pythonImportsCheck = [ "ray" ];

  meta = with lib; {
    description = "A unified framework for scaling AI and Python applications";
    homepage = "https://github.com/ray-project/ray";
    license = licenses.asl20;
    maintainers = with maintainers; [ billhuang ];
    platforms = [ "x86_64-linux" ];
  };
}
