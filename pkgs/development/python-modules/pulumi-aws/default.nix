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
  version = "7.10.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-aws";
    tag = "v${version}";
    hash = "sha256-7NE6Uu05geEf9sd+6eNTbw/GEpmr1bo3ydvJdzXo2ik=";
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
