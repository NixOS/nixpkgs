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

let
  functionDependencies = [
    grpcio
    prometheus-client
    protobuf
    ratelimit
  ];
in
buildPythonPackage rec {
  pname = "pulsar-client";
  version = "3.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "pulsar-client-python";
    tag = "v${version}";
    hash = "sha256-KdPLp0BmZnobU4F6tuMj2DY/ya4QHeGcM/eEAivoXNI=";
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

  pythonRemoveDeps = [
    # not avalilable in nixpkgs
    "apache-bookkeeper-client"
  ];

  optional-dependencies = {
    functions = functionDependencies;
    avro = [ fastavro ];
    all = functionDependencies ++ [ fastavro ];
  };

  nativeCheckInputs = [
    unittestCheckHook
  ] ++ lib.flatten (lib.attrValues (lib.filterAttrs (n: v: n != "all") optional-dependencies));

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
