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
    "protobuf"
    "grpcio"
    "pip"
    "semver"
  ];

  nativeCheckInputs = [
    pytest
    pytest-asyncio
    pytest-timeout
    pulumi-python
  ];

  disabledTestPaths = [
    # TODO: remove disabledTestPaths once the test is fixed upstream.
    # https://github.com/pulumi/pulumi/pull/19080#discussion_r2309611222
    "lib/test/provider/experimental/test_property_value.py::test_nesting"
  ];

  # https://github.com/pulumi/pulumi/blob/0acaf8060640fdd892abccf1ce7435cd6aae69fe/sdk/python/scripts/test_fast.sh#L10-L11
  # https://github.com/pulumi/pulumi/blob/0acaf8060640fdd892abccf1ce7435cd6aae69fe/sdk/python/scripts/test_fast.sh#L16
  installCheckPhase = ''
    runHook preInstallCheck
    declare -a _disabledTestPathsArray
    concatTo _disabledTestPathsArray disabledTestPaths
    ${python.executable} -m pytest --junit-xml= --ignore=lib/test/automation lib/test \
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
      teto
      tie
    ];
  };
}
