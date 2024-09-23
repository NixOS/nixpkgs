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
  # Version is independant of pulumi's.
  version = "6.51.0";

  pyproject = true;
  build-system = [ setuptools ];

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-aws";
    rev = "refs/tags/v${version}";
    hash = "sha256-aEyi4zFj0Q3KNBXjUX5J7nmmPCcnYn5w0mIC02gbGJc=";
  };

  sourceRoot = "${src.name}/sdk/python";

  propagatedBuildInputs = [
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
    changelog = "https://github.com/pulumi/pulumi-aws/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
