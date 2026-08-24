{
  lib,
  stdenv,
  buildPythonPackage,
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
  opentelemetry-exporter-prometheus,
  opentelemetry-proto,
  opentelemetry-sdk,
  prometheus-client,
  pydantic,
  py-spy,
  smart-open,
  virtualenv,
  # llm
  async-timeout,
  hf-transfer,
  jsonref,
  meson,
  ninja,
  # nixl,
  pybind11,
  typer,
  vllm,
  # observability
  memray,
  # rllib
  dm-tree,
  gymnasium,
  lz4,
  ormsgpack,
  scipy,
  # serve
  fastapi,
  jinja2,
  mmh3,
  starlette,
  uvicorn,
  watchfiles,
  # serve-async-inference
  celery,
  # serve-grpc
  pyopenssl,
  # tune
  tensorboardx,
}:

buildPythonPackage (finalAttrs: {
  pname = "ray";
  version = "2.57.0";
  format = "wheel";
  __structuredAttrs = true;

  disabled = pythonAtLeast "3.15";

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
          cp311 = "sha256-sMw9Q1vvbn/+hIgW5zadMO4pfojEwavGMjzJOD/zgm8=";
          cp312 = "sha256-WV0Iix/RrdZGVMbOviA+JZA3h7ZQ01xKPcAI1FHkikE=";
          cp313 = "sha256-caocUv54AM0he2Ab+f9VfCo//l+tWwD2eS2ppniyyRQ=";
          cp314 = "sha256-AssrX99BJG9rkwbIUkfucTG/7unTak7a5UZT4C7XiQw=";
        };
        aarch64-linux = {
          cp311 = "sha256-epgm4zv69GUhmrMp4F8D4/apGfzl0haS9axWakQnfLM=";
          cp312 = "sha256-7rHRrbYb0div/cX7VVrwSU/tj+xTuDV21MYPgR4GvpQ=";
          cp313 = "sha256-Xi2SWPdRZ291gdwK0wfC2RKQglRCNmEoye0MzQ9guEU=";
          cp314 = "sha256-4kiTkpbwyPRrPnNCFVV3YJSXKx28c9SAJHm5kXfCJp4=";
        };
        aarch64-darwin = {
          cp311 = "sha256-oBbWJYtTVxlS8qglFXGy1z2PawmBvmxh4WDMkBtxGHE=";
          cp312 = "sha256-jvWRV1xTF5P+t/d3RMUsNFCf9YtIsw0KO8tqFmYlawI=";
          cp313 = "sha256-IbZ+3cdRuoxl3u6GVAdcK0KFEQTJNs5CynlExLbsR5k=";
          cp314 = "sha256-eYoe4k5O3jnpAPzJNdhttfCA0np0xX4yOKUAS6kXEgA=";
        };
      };
    in
    fetchPypi {
      inherit (finalAttrs) pname version;
      format = "wheel";
      dist = pyShortVersion;
      python = pyShortVersion;
      abi = pyShortVersion;
      platform = platforms.${stdenv.hostPlatform.system} or { };
      hash =
        hashes.${stdenv.hostPlatform.system}.${pyShortVersion}
          or (throw "No hash specified for '${stdenv.hostPlatform.system}.${pyShortVersion}'");
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
      ++ self.serve-async-inference
      ++ self.serve-grpc
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
      opentelemetry-exporter-prometheus
      opentelemetry-proto
      opentelemetry-sdk
      prometheus-client
      pydantic
      py-spy
      requests
      smart-open
      virtualenv
    ];
    llm = lib.unique (
      [
        async-timeout
        hf-transfer
        jsonref
        jsonschema
        meson
        ninja
        # nixl
        pybind11
        typer
        vllm
      ]
      ++ self.data
      ++ self.serve
      ++ vllm.optional-dependencies.audio
    );
    observability = [
      memray
    ];
    rllib = lib.unique (
      [
        dm-tree
        gymnasium
        lz4
        ormsgpack
        pyyaml
        scipy
      ]
      ++ self.tune
    );
    serve = lib.unique (
      [
        fastapi
        # Undeclared upstream: `ray.serve._private.haproxy`, imported by the serve controller since
        # 2.57.0, needs it
        jinja2
        mmh3
        requests
        starlette
        uvicorn
        watchfiles
        # `ray-haproxy` (upstream, linux-only) is not packaged: it only ships an HAProxy binary, and
        # ray falls back to `haproxy` from PATH
      ]
      ++ self.default
    );
    serve-async-inference = lib.unique (
      [
        celery
      ]
      ++ self.serve
    );
    serve-grpc = lib.unique (
      [
        grpcio
        pyopenssl
      ]
      ++ self.serve
    );
    train = lib.unique (
      [
        pydantic
      ]
      ++ self.tune
    );
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
    changelog = "https://github.com/ray-project/ray/releases/tag/ray-${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ billhuang ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
