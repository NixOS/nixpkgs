{
  lib,
  stdenv,
  replaceVars,
  bash,
  buildBazelPackage,
  buildPythonPackage,
  buildNpmPackage,
  python,
  python39,
  fetchFromGitHub,
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
  psutil,
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

  # build dependencies
  bazel,
  colorama,
  coreutils,
  cython,
  git,
  perl,
  setproctitle,
  # test dependencies
  pytestCheckHook,
  pytest-asyncio,
  pytest-aiohttp,
  pytest-benchmark,
  pytest-httpserver,
  pytest-rerunfailures,
  pytest-sugar,
  pytest-lazy-fixture,
  pytest-timeout,
  pytest-docker-tools,
  mypy,
  joblib,
  torch,
  boto3,
  httplib2,
  jsonpatch,
  pyspark,
  pexpect,
  numba,
  scikit-learn,
}:

# Ray is a Python library with C extensions, built using Bazel.
# The official build process, defined in `python/setup.py`,
# combines the following steps in a single script:
# 1. Downloading Bazel
# 2. Parse the input to get Bazel flags and targets
# 3. Building the C extensions with Bazel
# 4. Building the Python package
#
# However, this process is incompatible with nixpkgs.
# To work around this, we must build the C extensions with Bazel separately from the Python package.

let
  pname = "ray";
  version = "2.42.0";
  src = fetchFromGitHub {
    owner = "ray-project";
    repo = "ray";
    rev = "ray-${version}";
    sha256 = "sha256-VWb+osUz/OlR5eoy+TX16Z2OL0xcNAOR04A8qFqhNto=";
  };

  dashboard = buildNpmPackage {
    inherit version src;
    pname = "ray-dashboard";
    sourceRoot = "${src.name}/python/ray/dashboard/client";
    npmDepsHash = "sha256-LceXVhoUlJjXxLwFfRqqH636FkdT34EWKAgie26txj8=";
    installPhase = ''
      cp -r build $out
    '';
  };

  # Bazel 6.x.x uses a built-in rules_python / rules_perl,
  # which downloads a standalone glibc python / perl interpreter.
  # This patch hooks into the download process to use the nixpkgs version instead.
  # This step is needed here because
  # 1. the python interpreter is used in the middle of the fetch phase in buildBazelPackage,
  # so it must be patched before the buildBazelPackage call.
  # 2. bazel doesn't have arm version of perl interpreter, causing the build to fail on arm.
  patched_rules_python = stdenv.mkDerivation {
    pname = "patched-rules-python";
    version = "0.9.0";
    src = fetchFromGitHub {
      owner = "bazelbuild";
      repo = "rules_python";
      rev = "0.9.0";
      sha256 = "sha256-TATs8LZF4cBKXvFYlFnXQBdXswpQ+ngdwe/bj+cieQI=";
    };
    dontBuild = true;
    patches = [
      (replaceVars ./rules_python_patchelf.patch {
        nixpkgs-python = "${python39}";
      })
    ];

    installPhase = ''
      cp -r . $out
    '';
  };

  patched_rules_perl = stdenv.mkDerivation {
    pname = "patched-rules-perl";
    version = "0.1.0";
    src = fetchFromGitHub {
      owner = "bazel-contrib";
      repo = "rules_perl";
      rev = "0.1.0";
      sha256 = "sha256-SrN2qHl6mDJ92Ohtisc1ZGw7PnxUWYhLFIwvzpfYgYs=";
    };
    dontBuild = true;
    patches = [
      (replaceVars ./rules_perl_patchelf.patch {
        nixpkgs-perl = "${perl}";
      })
    ];

    installPhase = ''
      cp -r . $out
    '';
  };

  bazel-build = buildBazelPackage {
    inherit pname version src;

    bazelFlags = [
      # override the builtin rules_python / rules_perl with the patched version
      "--override_repository=rules_python=${patched_rules_python}"
      "--override_repository=rules_perl=${patched_rules_perl}"
    ];

    patches = [
      # By default ray has -Werror flag enabled, which will cause the build to fail on warning.
      ./disable-werror.patch
    ];

    # the upstream support bazel 6.5.0
    # https://docs.ray.io/en/latest/ray-contribute/development.html#preparing-to-build-ray-on-linux
    bazel = bazel;
    bazelTargets = [ "//:ray_pkg" ];
    # required by ray
    PYTHON3_BIN_PATH = "${python}/bin/python";

    removeRulesCC = false;

    fetchAttrs = {
      # bazel will fetch different toolchains for different platforms
      # therefore it has different hash on different platforms
      sha256 =
        {
          x86_64-linux = "sha256-TRiHX+KkSaNdSgxAboqBpXhA51zTlNcwKtce2MrHZCE=";
          aarch64-linux = "sha256-Y84fGIidZDk8qFu6RG9R2detFyx4PZL5C8Q8t9cYEkk=";
        }
        .${stdenv.hostPlatform.system};

      nativeBuildInputs = [
        autoPatchelfHook
        git
        # for patchShebangs
        python39
        perl
      ];

      preInstall = ''
        # buildBazelPackages has dontFixup=true, so manually patch the output
        patchShebangs --build $bazelOut
        autoPatchelf $bazelOut

        # These files contain hard-coded paths, so patch them inplace.
        substituteInPlace $bazelOut/external/rules_foreign_cc/foreign_cc/private/framework/toolchains/linux_commands.bzl \
          --replace-fail "#!/usr/bin/env bash" "#!${bash}/bin/bash"
        substituteInPlace $bazelOut/external/openssl/config \
          --replace-fail "/usr/bin/env" "${coreutils}/bin/env"
      '';
    };

    nativeBuildInputs = [
      git
    ];

    buildAttrs = {
      installPhase = ''
        # remove the broken symlinks
        rm python/ray/air/examples/*.ipynb

        mkdir -p $out
        # python/ray/rllib is a symlink to rllib
        cp -r rllib $out/
        cp -r python $out/
        cp {README.rst,LICENSE,pyproject.toml} $out/
      '';
    };
  };
in
buildPythonPackage rec {
  inherit pname version;

  src = bazel-build;

  patchPhase = ''
    cd python
    # skip bazel build
    # otherwise it will try to call bazel again
    export SKIP_THIRDPARTY_INSTALL=1
    export SKIP_BAZEL_BUILD=1
    # patch the setup.py inplace to skip the `build` function entirely
    substituteInPlace setup.py \
      --replace-fail "build(False, False, False)" "pass"

    cp -r ${dashboard} ray/dashboard/client/build
  '';

  postBuildPhase = ''
    # mv dist/*.whl ./
  '';

  build-system = [
    cython
  ];

  dependencies = [
    # embedded dependencies
    psutil
    setproctitle
    colorama
    aiohttp
    # listed dependencies
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

  pythonImportsCheck = [ "ray" ];

  meta = {
    description = "Unified framework for scaling AI and Python applications";
    homepage = "https://github.com/ray-project/ray";
    changelog = "https://github.com/ray-project/ray/releases/tag/ray-${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ billhuang ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
