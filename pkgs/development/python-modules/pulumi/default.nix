{
  lib,
  pkgs,
  pulumiPackages,
  buildPythonPackage,
  pythonOlder,
  hatchling,
  protobuf,
  grpcio,
  dill,
  six,
  semver,
  pyyaml,
  debugpy,
  pip,
  pytest,
  pytest-asyncio,
  pytest-timeout,
  python,
}:
let
  inherit (pkgs.pulumi) pname version src;
  inherit (pulumiPackages) pulumi-language-python;
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

  disabled = pythonOlder "3.9";

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
  ];

  pythonRelaxDeps = [
    "grpcio"
    "pip"
    "semver"
  ];

  nativeCheckInputs = [
    pytest
    pytest-asyncio
    pytest-timeout
    pulumi-language-python
  ];

  # https://github.com/pulumi/pulumi/blob/0acaf8060640fdd892abccf1ce7435cd6aae69fe/sdk/python/scripts/test_fast.sh#L10-L11
  # https://github.com/pulumi/pulumi/blob/0acaf8060640fdd892abccf1ce7435cd6aae69fe/sdk/python/scripts/test_fast.sh#L16
  installCheckPhase = ''
    runHook preInstallCheck
    ${python.executable} -m pytest --ignore=lib/test/automation lib/test
    pushd lib/test_with_mocks
    ${python.executable} -m pytest
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
    # https://github.com/pulumi/pulumi/issues/16828
    broken = lib.versionAtLeast protobuf.version "5";
    maintainers = with lib.maintainers; [
      teto
      tie
    ];
  };
}
