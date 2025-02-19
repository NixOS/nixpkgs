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
  inherit (pulumiPackages) pulumi-cloudflare;
  src = pulumi-cloudflare.sdk;
  sourceRoot = "${src.name}-sdk/python";
in
buildPythonPackage {
  inherit (pulumi-cloudflare) pname version;
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

  pythonImportsCheck = [ "pulumi_cloudflare" ];

  meta = {
    description = "Pulumi package for creating and managing Cloudflare cloud resources";
    homepage = "https://github.com/pulumi/pulumi-cloudflare";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tie
    ];
  };
}
