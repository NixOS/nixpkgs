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
  version = "2.45.0";
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
        x86_64-darwin = "macosx_10_15_x86_64";
        x86_64-linux = "manylinux2014_x86_64";
      };
      # ./pkgs/development/python-modules/ray/prefetch.sh
      # Results are in ./ray-hashes.nix
      hashes = {
        x86_64-linux = {
          cp310 = "sha256-lI4RoSR/ewtFopEIuhz+36vYDx89t6Xe2laYITWI2Os=";
          cp311 = "sha256-0/jYyAf4mUZePOSPrU5R+EZxiG1zHj86SU87pQ7QlFg=";
          cp312 = "sha256-SC1F8vhn++yBRZXOmf5Vjp/xJDJ6YaSGpJdeanwiSn4=";
          cp313 = "sha256-UXR2/63UrxNcpd2K8BVBfABizLtEqGZ0Cilj3X/Q0vA=";
        };
        aarch64-linux = {
          cp310 = "sha256-yJ9P/Y5GI7bGkBQuVYE8EoaklBF1xi4QVoAbwTmtfqc=";
          cp311 = "sha256-r7uFydBa87JQlgLhO1rbCyCXmqerF3pxC0HwYENbt8I=";
          cp312 = "sha256-EVghAqF1dZGnU3bElH25gZ1fq3ZePtMHyITtZ2HbhkY=";
          cp313 = "sha256-a6WMvcCvLPRM5JGEu9qpiGtVnK1LpIIaAuhAIO2Ij9c=";
        };
        x86_64-darwin = {
          cp310 = "sha256-Ov5ZRYkGFkG2uH1abRgfcD2I647ewp9rMVRJ+zK1jTo=";
          cp311 = "sha256-QMjBRr7DcQxRHdA4DqfJMLQ0h8D5yMeLWDsOiQN0Uo8=";
          cp312 = "sha256-08MxE/QZa5I9eJX9y/a2gKFkLdEhRE6XRAHDUNp6yAk=";
          cp313 = "sha256-+g36O5YGeZ0lEmKudK+oYVLamDUcpCnUAmusV1mUNWk=";
        };
        aarch64-darwin = {
          cp310 = "sha256-ZebFvzyesazpuQ4+oEzHP388pP1Tq9IEjAp++kV9Lpg=";
          cp311 = "sha256-XcO17Yq29peNqnvX+CaMPkBC+seBHotmH3T4INeyYg8=";
          cp312 = "sha256-7u/x2kgDpdIyGivLX8FuINjxBFQ+jd9PMNGs9voi+sI=";
          cp313 = "sha256-08fzQLCNSCbERfaAJLtx5Chh9AVrBvUN9JoJV2E81yk=";
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
