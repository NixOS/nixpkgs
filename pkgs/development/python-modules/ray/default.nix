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

  # tests
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ray";
  version = "2.58.0";
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
          cp311 = "sha256-/D3S3s67NdHzaCwhHsnWyYB7MVLw3vpC7AlCgXAT4YA=";
          cp312 = "sha256-HiDEqNJWPZWA5498FSl6n4r+kkAbaYvOtBBsNLMMAcY=";
          cp313 = "sha256-siYhQKGZRYxa1veRfsdY0FfRZp+CQEj3hRGcbOJTk2M=";
          cp314 = "sha256-eXZbOtrsDs6K5OeujNWZ/1macebdTw53OhGHtHJhyns=";
        };
        aarch64-linux = {
          cp311 = "sha256-wgvEy6IdJsVjRJXWWZJ3rEfbf8M707JsDsd4H4zMOzw=";
          cp312 = "sha256-YvLxek1QFQlp3PCkzL2vva+ofWviJe4SCKe1a9Nzo3w=";
          cp313 = "sha256-uRG6i1F/LQnF1fMIZYU+JYnQOUF6VJEoPfIYktyGSYw=";
          cp314 = "sha256-IGllfupWv92rpYzyNTKlgtzGa8vfTLpNqK0f4qcsAoo=";
        };
        aarch64-darwin = {
          cp311 = "sha256-pVszZTqtwhwpi7ApzD7Zh4sysrCH/ikTxebg4tsfaZ4=";
          cp312 = "sha256-MIhjpkaNyWnR1SqZIzVp16KpwnRfWJt0/yd+l2lIYHc=";
          cp313 = "sha256-imZMsfvg9/15TsZiTdx3JJT4+q/O+oOlhWn5qcaZRWI=";
          cp314 = "sha256-2SRh/w4nhjWzwJrvx/5W4RSRSp2+er/T2caSrG3xlTs=";
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

  nativeCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Unified framework for scaling AI and Python applications";
    homepage = "https://github.com/ray-project/ray";
    changelog = "https://github.com/ray-project/ray/releases/tag/ray-${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "ray";
    maintainers = with lib.maintainers; [ billhuang ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
