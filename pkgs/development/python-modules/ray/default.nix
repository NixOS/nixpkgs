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
  version = "2.47.0";
in
buildPythonPackage rec {
  inherit pname version;
  format = "wheel";

  disabled = pythonOlder "3.9" || pythonAtLeast "3.14";

  src =
    let
      pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
      platforms = {
        aarch64-darwin = "macosx_11_0_arm64";
        aarch64-linux = "manylinux2014_aarch64";
        x86_64-darwin = "macosx_12_0_x86_64";
        x86_64-linux = "manylinux2014_x86_64";
      };
      # ./pkgs/development/python-modules/ray/prefetch.sh
      # Results are in ./ray-hashes.nix
      hashes = {
        x86_64-linux = {
          cp310 = "sha256-2bwLK5qXR5dBsFoO5AyngXDxoxICnwyz7GOcopdaLBQ=";
          cp311 = "sha256-mXjmK+MSTNGlSP2MoxTj/7j5Xzj+4r2Y/eOMdTkDnj4=";
          cp312 = "sha256-jTJr34I2TOkQx+BUFqIQ8IFCEGc6J1+1wA97ZayuVVE=";
          cp313 = "sha256-NfixG1EV5TCL/9id19yagkpNxdyP8L2Le2BUN/Wo42g=";
        };
        aarch64-linux = {
          cp310 = "sha256-gNBbc3pYggQNyUnZqzdOQuH1MHotKvIvWoapEzAsYZw=";
          cp311 = "sha256-rYHcke+f7mR0mSXeVHtLcRZ1cCkyb9WASYqzR7P/70w=";
          cp312 = "sha256-QpLtKSVLeTyLGXRwRetE4PotXyElmxe6tj5D4Jl7edA=";
          cp313 = "sha256-4+jlADusJGgYYzAVX+u7sKZo2lBa+paYCEUUYKVcxI4=";
        };
        x86_64-darwin = {
          cp310 = "sha256-CFXvVo2pab2XCLCVKYhPb7HZYlyTSjFMRQ8MXiQqkT4=";
          cp311 = "sha256-I5ByFBG+nVoKicH02AvcSMOjZgWjjamn9bWkYmE8XSE=";
          cp312 = "sha256-S6cA3Uth7iWNeQBk0XbU29ibNj89MneLLK3s1A16PHI=";
          cp313 = "sha256-bCYYiU0/LJg6E9na71kjxLMk6V0zrGH3+iA7vtRO/5U=";
        };
        aarch64-darwin = {
          cp310 = "sha256-G2ODPZcJl3f2cqh/H0NEaPrTtLTHIRAljNF3nk7uun4=";
          cp311 = "sha256-pPDYfOr5GMUcXo3U1ZRVk02xjF8YRRYrnJWP5S6sXT4=";
          cp312 = "sha256-WRm9UuWkaR/mXqZ+3OuCcwg4+sF7woSsLRlu7G9SURg=";
          cp313 = "sha256-fExn+Jw2AkrnQFXh0zNvdp2gQrGQSoiDQJfZaPe5DuU=";
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
