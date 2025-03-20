{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  parver,
  pulumi,
  pythonOlder,
  semver,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pulumi-aws";
  # Version is independent of pulumi's.
  version = "6.66.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-aws";
    tag = "v${version}";
    hash = "sha256-BPL4B0KwXQld+/aPTJKhsFMPEbJByccTj+Zs70b8O6A=";
  };

  sourceRoot = "${src.name}/sdk/python";

  build-system = [ setuptools ];

  dependencies = [
    parver
    pulumi
    semver
  ];

  # Checks require cloud resources
  doCheck = false;

  pythonImportsCheck = [ "pulumi_aws" ];

  meta = with lib; {
    description = "Pulumi python amazon web services provider";
    homepage = "https://github.com/pulumi/pulumi-aws";
    changelog = "https://github.com/pulumi/pulumi-aws/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
