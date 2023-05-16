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
<<<<<<< HEAD
  version = "6.0.4";
=======
  version = "5.40.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumi-aws";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-YukXw7/KDfw6iYoN6UpF5XGb5D6oaaXTOpsduqZZz2Y=";
=======
    hash = "sha256-DMSBQhBxbVfU7ULkLI8KV7JJLBsaVb/Z9BZZG2GEOzQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    changelog = "https://github.com/pulumi/pulumi-aws/releases/tag/v${version}";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
