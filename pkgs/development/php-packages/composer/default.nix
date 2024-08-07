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
  version = "2.8.1";

  # Hash used by ../../../build-support/php/pkgs/composer-phar.nix to
  # use together with the version from this package to keep the
  # bootstrap phar file up-to-date together with the end user composer
  # package.
  passthru.pharHash = "sha256-kws3b70hR6Yj6ntwTrnTuLDWBymSIHqgU1qiH28FN44=";

  composer = callPackage ../../../build-support/php/pkgs/composer-phar.nix {
    inherit (finalAttrs) version;
    inherit (finalAttrs.passthru) pharHash;
  };

  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    rev = finalAttrs.version;
    hash = "sha256-5UcbEx1d5jEz73mTFTacifl6ykxm6yQw3wvkJQtINHs=";
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
    outputHash = "sha256-FfFwx5E2LVDSqo2P31fqtvk2P30XnTm+TUqhNSHTt/M=";
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
