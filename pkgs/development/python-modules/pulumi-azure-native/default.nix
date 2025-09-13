{
  lib,
  pulumiPackages,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  parver,
  pulumi,
  semver,
  typing-extensions,
}:
let
  inherit (pulumiPackages) pulumi-azure-native;
  src = pulumi-azure-native.sdk;
  sourceRoot = "${src.name}-sdk/python";
in
buildPythonPackage {
  inherit (pulumi-azure-native) pname version;
  inherit src sourceRoot;

  outputs = [
    "out"
    "dev"
  ];

  pyproject = true;

  disabled = pythonOlder "3.9";

  build-system = [ setuptools ];

  dependencies = [
    parver
    pulumi
    semver
  ]
  ++ lib.optional (pythonOlder "3.11") typing-extensions;

  pythonImportsCheck = [ "pulumi_azure_native" ];

  meta = {
    description = "Native Pulumi package for creating and managing Azure resources";
    homepage = "https://github.com/pulumi/pulumi-azure-native";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      veehaitch
      trundle
      tie
    ];
  };
}
