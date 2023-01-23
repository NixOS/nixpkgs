{ python3Packages, platformioPackages, fetchFromGitHub }:

{
  callPackage = python3Packages.newScope platformioPackages;
  platformio-chrootenv = platformioPackages.callPackage ./chrootenv.nix { };
  platformio-core = platformioPackages.callPackage ./core.nix { };
}
