{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build
  setuptools,
  cmake,
  pkg-config,

  # dependencies
  libpulsar,
  pybind11,
  certifi,

  # optional dependencies
  fastavro,
  grpcio,
  prometheus-client,
  protobuf,
  ratelimit,

  # test
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pulsar-client";
  version = "3.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "pulsar-client-python";
    tag = "v${version}";
    hash = "sha256-0EeQiYEYdER6qPQUYsk/OwYKiPWG0oymG5eiB01Oysk=";
  };

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libpulsar
    pybind11
  ];

  preBuild = ''
    make -j$NIX_BUILD_CORES
    make install
    cd ..
  '';

  dependencies = [ certifi ];

  optional-dependencies = {
    functions = [
      # apache-bookkeeper-client
      grpcio
      prometheus-client
      protobuf
      ratelimit
    ];
    avro = [ fastavro ];
    all = lib.flatten (lib.attrValues (lib.filterAttrs (n: v: n != "all") optional-dependencies));
  };

  nativeCheckInputs = [
    unittestCheckHook
  ]
  ++ optional-dependencies.all;

  unittestFlagsArray = [
    "-s"
    "test"
  ];

  pythonImportsCheck = [ "pulsar" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Apache Pulsar Python client library";
    homepage = "https://pulsar.apache.org/docs/next/client-libraries-python/";
    changelog = "https://github.com/apache/pulsar-client-python/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gaelreyrol ];
  };
}
