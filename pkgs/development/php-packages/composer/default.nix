{
  lib,
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
  version = "2.9.8";

  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    tag = finalAttrs.version;
    hash = "sha256-g9r6l0qjpAxVw0q3wbrUstnq2lISMSLgr13FsjcnHDQ=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  # Bootstrapping Composer (source) with Composer (PHAR distribution).
  # Override the default `composer` attribute to prevent infinite recursion.
  composer = callPackage ../../../build-support/php/pkgs/composer-phar.nix {
    inherit (finalAttrs) version;
    inherit (finalAttrs.passthru) pharHash;
  };

  vendorHash = "sha256-GNu1BMKPi0SKH6+456NPnAVuNOk2ylONogtLygdi1y8=";

  postInstall = ''
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
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  # Hash used by ../../../build-support/php/pkgs/composer-phar.nix to
  # use together with the version from this package to keep the
  # bootstrap phar file up-to-date together with the end user composer
  # package.
  passthru.pharHash = "sha256-WbLFDhDK+g2O/Bnt6aMm14LwlsZ0omuvmM8ELOI96JA=";

  meta = {
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    description = "Dependency Manager for PHP";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    mainProgram = "composer";
    teams = [ lib.teams.php ];
  };
})
