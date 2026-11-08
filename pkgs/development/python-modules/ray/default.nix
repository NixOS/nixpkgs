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
  grpcio-reflection,
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
  version = "2.60.0";
  format = "wheel";

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
          cp311 = "sha256-4if2sq+KtGJt2aNaWGCzOGQyXqE3OD1X+FTUY37j/qI=";
          cp312 = "sha256-uVG0CWWUemNhWDCRa+BPJkQNI03h6aKdvyFV0D+prSo=";
          cp313 = "sha256-f3+yCaLfN18UHo0OEy52RLjo7+OFW3D0hE+/sU6mZyw=";
          cp314 = "sha256-DsP0SvKWHYytL41pm0cOL2hD1EPMxvQDlIru63etNcM=";
        };
        aarch64-linux = {
          cp311 = "sha256-1R1iPWr070n13ufTNAuVtEzcd0tqeWToYyrN/Oi576w=";
          cp312 = "sha256-DwjHrwY1g7aL5V/quQ3QViVdTWiaN+Z7yU/K15gAop4=";
          cp313 = "sha256-A7Bc4j0wnkwtFia/lDQ+Oj6eJvpMDSynC2b4a4TJfyY=";
          cp314 = "sha256-sgIVpX+IeyA0Y9W4B0yLEzvOI66JyFUiufky3cWJMB8=";
        };
        aarch64-darwin = {
          cp311 = "sha256-qkIHy/QIF9C/TjWqeTuKOphwCMNCwOjLzeGKbjG2uFo=";
          cp312 = "sha256-ue49K9MhC5fi4lMEYzOhLghhfG+z5qH6wIJonWcJZgo=";
          cp313 = "sha256-zPGU/1NM2ClNUrQyfRRXpcDWAfSMwchJyJjx1NvEQyg=";
          cp314 = "sha256-Nn1u/noVZR11qgx1SFP4TvJ9kx1J68UxoweQKo5yiBE=";
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
        grpcio-reflection
        jinja2
        mmh3
        numpy
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
