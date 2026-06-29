{
  lib,
  pkgs,
  pulumiPackages,
  buildPythonPackage,
  hatchling,
  protobuf,
  grpcio,
  dill,
  six,
  semver,
  pyyaml,
  debugpy,
  pip,
  opentelemetry-api,
  opentelemetry-sdk,
  opentelemetry-instrumentation-grpc,
  opentelemetry-exporter-otlp-proto-grpc,
  pytest,
  pytest-asyncio,
  pytest-timeout,
  python,
}:
let
  inherit (pkgs.pulumi) pname version src;
  inherit (pulumiPackages) pulumi-python;
  sourceRoot = "${src.name}/sdk/python";
in
buildPythonPackage {
  inherit
    pname
    version
    src
    sourceRoot
    ;

  outputs = [
    "out"
    "dev"
  ];

  pyproject = true;

  build-system = [ hatchling ];

  dependencies = [
    protobuf
    grpcio
    dill
    six
    semver
    pyyaml
    debugpy
    pip
    opentelemetry-api
    opentelemetry-sdk
    opentelemetry-instrumentation-grpc
    opentelemetry-exporter-otlp-proto-grpc
  ];

  pythonRelaxDeps = [
    "protobuf"
    "grpcio"
    "pip"
    "semver"
    "opentelemetry-api"
    "opentelemetry-sdk"
    "opentelemetry-instrumentation-grpc"
    "opentelemetry-exporter-otlp-proto-grpc"
  ];

  nativeCheckInputs = [
    pytest
    pytest-asyncio
    pytest-timeout
    pulumi-python
  ];

  # CheckPhase script based on:
  # https://github.com/pulumi/pulumi/blob/0acaf8060640fdd892abccf1ce7435cd6aae69fe/sdk/python/scripts/test_fast.sh#L10-L11
  # https://github.com/pulumi/pulumi/blob/0acaf8060640fdd892abccf1ce7435cd6aae69fe/sdk/python/scripts/test_fast.sh#L16
  # Script updated in https://github.com/pulumi/pulumi/pull/21365
  #
  # Ignore lib/test/langhost because tests require `uv` / virtualenv which is not supported in the Nix sandbox.
  installCheckPhase = ''
    runHook preInstallCheck
    declare -a _disabledTestPathsArray
    concatTo _disabledTestPathsArray disabledTestPaths
    ${python.executable} -m pytest --junit-xml= \
      --ignore=lib/test/automation \
      --ignore=lib/test/langhost \
      lib/test \
      "''${_disabledTestPathsArray[@]/#/--deselect=}"
    pushd lib/test_with_mocks
    ${python.executable} -m pytest --junit-xml=
    popd
    runHook postInstallCheck
  '';

  # Allow local networking in tests on Darwin
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pulumi" ];

  meta = {
    description = "Modern Infrastructure as Code. Any cloud, any language";
    homepage = "https://www.pulumi.com";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tie
      untio11
    ];
  };
}
