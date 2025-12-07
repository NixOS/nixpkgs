{
  lib,
  fetchFromGitHub,
  php,
}:

let
  version = "5.2.0";
in
php.buildComposerWithPlugin {
  pname = "cyclonedx/cyclonedx-php-composer";
  inherit version;

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-php-composer";
    rev = "v${version}";
    hash = "sha256-0fb1QiuVJqcB7CAEyB0y60/O9iiibT06mccZYe52dFQ=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-Uk7bT5NmobiUnOI4mSTQsRRiH8E9dLlU+en7IsIbI8M=";

  meta = {
    changelog = "https://github.com/CycloneDX/cyclonedx-php-composer/releases/tag/v${version}";
    description = "Composer plugin that facilitates the creation of a CycloneDX Software Bill of Materials (SBOM) from PHP Composer projects";
    homepage = "https://github.com/CycloneDX/cyclonedx-php-composer";
    license = lib.licenses.asl20;
    mainProgram = "composer";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
