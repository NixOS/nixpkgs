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
  version = "2.48.0";
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
          cp310 = "sha256-ZJ7ZRC3C05E1xZO2zww46DVRcLkmcjZat6PLyVjEJjQ=";
          cp311 = "sha256-RtS0KlhJLex5yq0tViNEaJpPmagoruqBGgzSzWU1U+8=";
          cp312 = "sha256-pC7TtkD0tZmj/IBnyD7mBJfA8D0HDXp98Co4j6F6VGs=";
          cp313 = "sha256-JeS3n8yPhJ1y2xrMTwPzcAjFwLdF32PYowzTVna2VF4=";
        };
        aarch64-linux = {
          cp310 = "sha256-+CCVC8RNewAMIjNC9cgAycCOf9iVJCARJTiOohHKrRo=";
          cp311 = "sha256-JKcPQW7AvhS5dfFgBEgFzLSMxrxQ3mMpg+uPCo4WaCs=";
          cp312 = "sha256-8c8z0mAxb5L3dVgYXxw2/DVQbXbuf9/tn1tw+cS9un8=";
          cp313 = "sha256-Yi5rzbeNmAQNh76pTmXQu2zMCuG0MpTGvWn1Qr8o4JI=";
        };
        x86_64-darwin = {
          cp310 = "sha256-M72kdTrQrNK1JMkVgInUNIbNRMxZ/pcEZkNbwpaP3i0=";
          cp311 = "sha256-uUUA/i0X5JH+LpvUo79i3yF+IajyhFAzw1PU0uokD3M=";
          cp312 = "sha256-Wm9XEm6sndMoYongfpHoewVHkvlpi298yriLYkgWtUI=";
          cp313 = "sha256-V0K3KlFK/l1g9BMwIAzVCDduFsZQ9pYuYjN6pILWoMY=";
        };
        aarch64-darwin = {
          cp310 = "sha256-bKK5zkWtNgy+KZaYL7Imkez+ZVPsj5eiVIKV8PlqrHg=";
          cp311 = "sha256-S5uSrCljX1Ve80E0fZpj2/ArfZRjRyOa88CeNkvEXPg=";
          cp312 = "sha256-jeeZ87CJb0jTBtXkoE/GA3oIxJXUX5x5k1NE5Wk+PPg=";
          cp313 = "sha256-p6bYMNncWui7FW/N6aGtq39O2wBPA5GKck2IXs64Jk0=";
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
