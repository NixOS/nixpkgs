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
  passthru.pharHash = "sha256-BJuODtnyZNdwoFEIWM/7w1QBUQdZ7cmnhLOlxuAgvKw=";

  composer = callPackage ../../../build-support/php/pkgs/composer-phar.nix {
    inherit (finalAttrs) version;
    inherit (finalAttrs.passthru) pharHash;
  };

  pname = "composer";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    rev = finalAttrs.version;
    hash = "sha256-Rev3OW1G+LVgJmHLwuV5u0s7F7lKrvtI43eS7y9SAYA=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/composer \
      --prefix PATH : ${lib.makeBinPath [ _7zz cacert curl git unzip xz ]}
  '';

  vendorHash = "sha256-JLMhjOradyo64mPNos0qtM5bTnAYTRvSWnFUQrLQNjw=";

  meta = {
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    description = "Dependency Manager for PHP";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    mainProgram = "composer";
    maintainers = lib.teams.php.members;
  };
})
