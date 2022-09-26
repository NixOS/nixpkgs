{ aiohttp
, aiohttp-cors
, aiorwlock
, aiosignal
, attrs
, bazel_4
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
let
  pname = "ray";
  version = "2.0.0";
  pyShortVersion = "cp${builtins.replaceStrings ["."] [""] python.pythonVersion}";

  bazel-build = buildBazelPackage {
    pname = "ray";
    version = "2.0.0";
    bazel = bazel_4;
    src = fetchFromGitHub {
      owner = "ray-project";
      repo = "ray";
      rev = "ray-2.0.0";
      sha256 = "1h5zqwz8r9psaskh2qnjr3n5g03dcapq4nqi49kmplcx886bfjjg";
    };
    bazelTarget = "//:ray_pkg";
    bazelBuildFlags = [
      # the flag used in the original setup.py
      "--verbose_failures"
    ];
    fetchAttrs = {
      sha256 = "vVj2mFyU/toNox1++rbQuctaeBTfUmn4965hILAZegM=";
    };

    nativeBuildInputs = [
      cython
    ];

    removeRulesCC = false;

    buildAttrs = {
      preBuild = ''
        patchShebangs ../output/external/cython/cython.py
      '';

      installPhase = ''
        mkdir -p $out
        cp -rL ./python $out/
        cp ./{README.rst,LICENSE} $out/
      '';
    };
  };

  ray = buildPythonPackage rec {
    inherit pname version;

    src = bazel-build;

    nativeBuildInputs = [ pythonRelaxDepsHook ];
    pythonRelaxDeps = [ "grpcio" "click" ];

    patchPhase = ''
      cd python
      export SKIP_THIRDPARTY_INSTALL=1
      export SKIP_BAZEL_BUILD=1
      # completely skip bazel build
      # otherwise it will try to call bazel again
      substituteInPlace setup.py \
        --replace "build(False, False, False)" "pass"
    '';

    postBuildPhase = ''
      # mv dist/*.whl ./
    '';

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

    # ray has a lot of tests,
    # many of which are missing some extra dependencies
    # and some just hang for unknown reason,
    # extra work is needed to identify these tests.
    pythonImportsCheck = [ "ray" ];
    doCheck=false;

    meta = with lib; {
      description = "A unified framework for scaling AI and Python applications";
      homepage = "https://github.com/ray-project/ray";
      license = licenses.asl20;
      maintainers = with maintainers; [ billhuang ];
      platforms = platforms.linux;
    };
  };
in
  ray
