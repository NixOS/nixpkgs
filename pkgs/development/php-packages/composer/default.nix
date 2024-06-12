{ lib
, callPackage
, fetchFromGitHub
, php
, unzip
, _7zz
, xz
, git
, curl
, cacert
, makeBinaryWrapper
}:

php.buildComposerProject (finalAttrs: {
  # Hash used by ../../../build-support/php/pkgs/composer-phar.nix to
  # use together with the version from this package to keep the
  # bootstrap phar file up-to-date together with the end user composer
  # package.
  passthru.pharHash = "sha256-qrlAzVPShaVMUEZYIKIID8txgqS6Hl95Wr+xBBSktL4=";

  composer = callPackage ../../../build-support/php/pkgs/composer-phar.nix {
    inherit (finalAttrs) version;
    inherit (finalAttrs.passthru) pharHash;
  };

  pname = "composer";
  version = "2.7.7";

  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    rev = finalAttrs.version;
    hash = "sha256-N8el4oyz3ZGIXN2qmpf6Df0SIjuc1GjyuMuQCcR/xN4=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/composer \
      --prefix PATH : ${lib.makeBinPath [ _7zz cacert curl git unzip xz ]}
  '';

  vendorHash = "sha256-4EyMtf4i7GqL/8eGZqBuk0Afagzo/2EbpcWekc7iHDU=";

  meta = {
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    description = "Dependency Manager for PHP";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
