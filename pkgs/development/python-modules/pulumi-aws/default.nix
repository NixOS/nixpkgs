{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, parver
, pulumi
, pythonOlder
, semver
}:

buildPythonPackage rec {
  pname = "pulumi-aws";
  # Version is independant of pulumi's.
  version = "5.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-aws";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZpbWqhTScWOlcVsX4OYlA5dYQg0UsfOhMLllXjEDdUI=";
  };

  sourceRoot = "${src.name}/sdk/python";

  propagatedBuildInputs = [
    parver
    pulumi
    semver
  ];

  # Checks require cloud resources
  doCheck = false;

  pythonImportsCheck = [
    "pulumi_aws"
  ];

  meta = with lib; {
    description = "Pulumi python amazon web services provider";
    homepage = "https://github.com/pulumi/pulumi-aws";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
