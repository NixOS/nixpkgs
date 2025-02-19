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
  inherit (pulumiPackages) pulumi-aws;
  src = pulumi-aws.sdk;
  sourceRoot = "${src.name}-sdk/python";
in
buildPythonPackage {
  inherit (pulumi-aws) pname version;
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
  ] ++ lib.optional (pythonOlder "3.11") typing-extensions;

  pythonImportsCheck = [ "pulumi_aws" ];

  meta = {
    description = "Pulumi package for creating and managing Amazon Web Services (AWS) cloud resources";
    homepage = "https://github.com/pulumi/pulumi-aws";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tie
    ];
  };
}
