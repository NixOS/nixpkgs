{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  callPackage,
  php,
  unzip,
  _7zz,
  xz,
  git,
  curl,
  cacert,
  makeBinaryWrapper,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "composer";
  version = "2.7.7";

  # Hash used by ../../../build-support/php/pkgs/composer-phar.nix to
  # use together with the version from this package to keep the
  # bootstrap phar file up-to-date together with the end user composer
  # package.
  passthru.pharHash = "sha256-qrlAzVPShaVMUEZYIKIID8txgqS6Hl95Wr+xBBSktL4=";

  composer = callPackage ../../../build-support/php/pkgs/composer-phar.nix {
    inherit (finalAttrs) version;
    inherit (finalAttrs.passthru) pharHash;
  };

  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    rev = finalAttrs.version;
    hash = "sha256-N8el4oyz3ZGIXN2qmpf6Df0SIjuc1GjyuMuQCcR/xN4=";
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
    outputHash = "sha256-AsuiTDXJs7jN4N/dJr10BT2PH0f6K2CWDvI8zQW5L9c=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -ar ${finalAttrs.vendor}/* $out/
    chmod +w $out/bin

    wrapProgram $out/bin/composer \
      --prefix PATH : ${
        lib.makeBinPath [
          _7zz
          curl
          git
          unzip
          xz
        ]
      }

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    description = "Dependency Manager for PHP";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    mainProgram = "composer";
    maintainers = lib.teams.php.members;
  };
})
