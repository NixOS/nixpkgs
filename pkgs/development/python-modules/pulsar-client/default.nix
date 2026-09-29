{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # nativeBuildInputs
  cmake,
  pkg-config,

  # dependencies
  libpulsar,
  pybind11,
  certifi,

  # optional-dependencies
  fastavro,
  grpcio,
  prometheus-client,
  protobuf,
  ratelimit,

  # tests
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pulsar-client";
  version = "3.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "pulsar-client-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZmuZskkviHantE5vOJd0Di8aqu086G36TQJoEFW2VaY=";
  };

  patches = [
    # Remove TLS bindings removed in libpulsar 4.x
    ./fix-libpulsar-4.patch
  ];

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
  };

  nativeCheckInputs = [
    unittestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  unittestFlagsArray = [
    "-s"
    "test"
  ];

  pythonImportsCheck = [ "pulsar" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Apache Pulsar Python client library";
    homepage = "https://pulsar.apache.org/docs/next/client-libraries-python/";
    changelog = "https://github.com/apache/pulsar-client-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
