{
  lib,
<<<<<<< HEAD
  fetchFromGitHub,
  callPackage,
  php,
  makeBinaryWrapper,
  _7zz,
  curl,
  gitMinimal,
  unzip,
  xz,
  versionCheckHook,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "composer";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    tag = finalAttrs.version;
    hash = "sha256-Ke+QGcKPqm1wEVVYgUCL0K3nT+qmzWpRX6HcZnzdhgA=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  # Bootstrapping Composer (source) with Composer (PHAR distribution).
  # Override the default `composer` attribute to prevent infinite recursion.
=======
  stdenvNoCC,
  fetchFromGitHub,
  callPackage,
  php,
  unzip,
  _7zz,
  xz,
  gitMinimal,
  curl,
  cacert,
  makeBinaryWrapper,
  versionCheckHook,
}:

/*
    XXX IMPORTANT

    Make sure to check if the `vendorHash` of `buildComposerProject2` changes when updating!
    See https://github.com/NixOS/nixpkgs/issues/451395
*/

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "composer";
  version = "2.8.12";

  # Hash used by ../../../build-support/php/pkgs/composer-phar.nix to
  # use together with the version from this package to keep the
  # bootstrap phar file up-to-date together with the end user composer
  # package.
  passthru.pharHash = "sha256-9EbqcZcIu4X8v07xje9dBRXx+bTXA/bYIMnBZW4QovI=";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  composer = callPackage ../../../build-support/php/pkgs/composer-phar.nix {
    inherit (finalAttrs) version;
    inherit (finalAttrs.passthru) pharHash;
  };

<<<<<<< HEAD
  vendorHash = "sha256-cqELlLH7d5KR62uVn7VtpQhVjkhXZkclXfc5d8RAG5Y=";

  postInstall = ''
=======
  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    tag = finalAttrs.version;
    hash = "sha256-UHCsdJmoE7X2ZiiBAWfC004FUMqHyd0URt+v8R3hn70=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildInputs = [ php ];

  vendor = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-vendor";

    inherit (finalAttrs) src version;

    nativeBuildInputs = [
      cacert
      finalAttrs.composer
    ];

    dontPatchShebangs = true;
    doCheck = true;

    buildPhase = ''
      runHook preBuild

      composer install --no-dev --no-interaction --no-progress --optimize-autoloader

      runHook postBuild
    '';

    checkPhase = ''
      runHook preCheck

      composer validate

      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall

      cp -ar . $out/

      runHook postInstall
    '';

    env = {
      COMPOSER_CACHE_DIR = "/dev/null";
      COMPOSER_DISABLE_NETWORK = "0";
      COMPOSER_HTACCESS_PROTECT = "0";
      COMPOSER_MIRROR_PATH_REPOS = "1";
      COMPOSER_ROOT_VERSION = finalAttrs.version;
    };

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-gnCPcp+c2dFL+9MJf0JRCQ5E95/dET1F0ZZAYj/rWq4=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -ar ${finalAttrs.vendor}/* $out/
    chmod +w $out/bin

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    wrapProgram $out/bin/composer \
      --prefix PATH : ${
        lib.makeBinPath [
          _7zz
          curl
          gitMinimal
          unzip
          xz
        ]
      }
<<<<<<< HEAD
=======

    runHook postInstall
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD

  # Hash used by ../../../build-support/php/pkgs/composer-phar.nix to
  # use together with the version from this package to keep the
  # bootstrap phar file up-to-date together with the end user composer
  # package.
  passthru.pharHash = "sha256-Rx8thXq/DsGK97BV5hRyIU2RrbJPm9u7hkwcZPqtfdY=";
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    description = "Dependency Manager for PHP";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    mainProgram = "composer";
    teams = [ lib.teams.php ];
  };
})
