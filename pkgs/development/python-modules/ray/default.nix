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
  aiosignal,
  click,
  filelock,
  frozenlist,
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
  # cpp
  ray-cpp,
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

  cpp ? false,
}:

let
  pname = "ray" + lib.optionalString cpp "-cpp";
  version = "2.44.0";
in
buildPythonPackage rec {
  inherit pname version;
  format = "wheel";

  disabled = pythonOlder "3.9" || pythonAtLeast "3.13";

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
      hashes =
        {
          ray = {
            x86_64-linux = {
              cp39 = "sha256-Ucy9W/gEXWnx+NL4WpL2aoKBjz2S1wx3xmJ1eYHDDZ8=";
              cp310 = "sha256-tP29SytbReQT3Bahmkq/UADTbDxYVJCNykaXMj/11+E=";
              cp311 = "sha256-hk8KabPNfKTrcEP3953JzotxosmC7ux/EX9I8oRrcTw=";
              cp312 = "sha256-DWWsUjgB5Ao5e79VL0BoZ7uUad0mEEbKY83C7DEQ24c=";
            };
            aarch64-linux = {
              cp39 = "sha256-Lxj0j8N95kAxXZNgECbfqiPwr0y6jwd9sT8dd+mR2a8=";
              cp310 = "sha256-qZ+7mtLBryIYcNhrio49WcGKVROt3p1wiKSiddxZ2n8=";
              cp311 = "sha256-wzcjfnqKHYcC3PZ+CpjqjNTsA1fSiL8IFviZDCWNi8M=";
              cp312 = "sha256-KpEeaZ5IOsSHkRC2CLBrNeYCGRwOe5cybKSXxcqv5qg=";
            };
            x86_64-darwin = {
              cp39 = "sha256-4373wSlDArrp2SFoCi2jR5iMHh4qmCo+coktEa4A4j4=";
              cp310 = "sha256-YyeQwyfmkxp6jMrd6P06+utzrTgvh99N1HpSyov+BRw=";
              cp311 = "sha256-++SDLLLvz8BJPqR0K0gosesNq8/t+H9kvmvh0M6HTGk=";
              cp312 = "sha256-U9x16itP2GnqSmzKneXgKqJPLw0Y4KCLinZasr5l3Rw=";
            };
            aarch64-darwin = {
              cp39 = "sha256-Ef62eG+CAQRke2aiklRVNsA36Cl/FP4BI0t7JN2PJzk=";
              cp310 = "sha256-XfvyazCuw35dRCXGYBReVSApmohVMkaG4vF/yGAb9Mg=";
              cp311 = "sha256-Uzcifcn4CEKAwpRWmIokTKm0zg+8c4XXMHASD0fkaXk=";
              cp312 = "sha256-OY6b4ZPJf3NK8Bnw76zh9FyUGVuW7MSmR61gdlDfVyw=";
            };
          };
          ray-cpp = {
            x86_64-linux = {
              cp39 = "sha256-kTaV6QALTT8jNAHqQ82uziec6lqN84iIjZiH5qazRZ8=";
              cp310 = "sha256-t/VCAL3iQzPb2rspg73hUCUDyd84xZmlAJJoYOtihRU=";
              cp311 = "sha256-t4hSRczqsvf37ECbmDqR4iq0JxKkAdrQ/oW+0O9di/Q=";
              cp312 = "sha256-BC/m+rdF97/Jp5X9njHSxMSEy4Pi438uHJupr525x1w=";
            };
            aarch64-linux = {
              cp39 = "sha256-jingq//nNG8Wj0AtruPH8qSD4plRb9E1525SX3hcohQ=";
              cp310 = "sha256-W+K4uhwDQT3Xrp/oqZfhcBWAIDUIfqAtQy/fQ4xsmVI=";
              cp311 = "sha256-x9SHTi1nSRJO1WmmGTdh3gusqNkOCK/zKrp5qGFbFu8=";
              cp312 = "sha256-9ncekE1QI38SnsBEefDLo2PlE9MsPFiF/4z5/HAK6Vk=";
            };
            x86_64-darwin = {
              cp39 = "sha256-qjKT+zkv1+ZC3bBo1WQOQK16o1Oqor/JVmUGi/zSo4Y=";
              cp310 = "sha256-rnumGJAOtDQZYkbj5OZ/wPCOFhNApR7kXV6843JPQ5g=";
              cp311 = "sha256-z5W/Oe0bCbFmyaNtC4rCQloEASuYWp7KJkNbvo241jE=";
              cp312 = "sha256-60bNO5Ed+itmSy2EFHFPHLiE9zpfJ6WDiQf46JUX2QA=";
            };
            aarch64-darwin = {
              cp39 = "sha256-M0V+fkdPKhLdb0gjdk3T9WfwQCebdSGNaQqe7w5qUyc=";
              cp310 = "sha256-DYMdyTb+8USP+COvMd5CkccgKD/Wp6Pqa6saaRBgDjg=";
              cp311 = "sha256-ZBVxVJD2GiiSeNKl1XdjJZZUSJueJHeJj2RsCBb/bs0=";
              cp312 = "sha256-j3YfioT2siNwtaVUCB5XILvQqYfM/E7WDRjcEiF9KOA=";
            };
          };
        }
        .${pname};
    in
    fetchPypi {
      pname = "ray" + lib.optionalString cpp "_cpp";
      inherit version format;
      dist = pyShortVersion;
      python = pyShortVersion;
      abi = pyShortVersion;
      platform = platforms.${stdenv.hostPlatform.system} or { };
      hash = hashes.${stdenv.hostPlatform.system}.${pyShortVersion} or { };
    };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  dependencies = [
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
    cpp = [ ray-cpp ];
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

  postInstall = lib.optionalString (!cpp) ''
    chmod +x $out/${python.sitePackages}/ray/core/src/ray/{gcs/gcs_server,raylet/raylet}
  '';

  pythonImportsCheck = [ "ray" ];

  passthru.tests = {
    inherit ray-cpp;
  };

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
