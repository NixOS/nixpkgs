{ lib, callPackage, fetchFromGitHub, fetchpatch, php, unzip, _7zz, xz, git, curl, cacert, makeBinaryWrapper }:

php.buildComposerProject (finalAttrs: {
  # Hash used by ../../../build-support/php/pkgs/composer-phar.nix to
  # use together with the version from this package to keep the
  # bootstrap phar file up-to-date together with the end user composer
  # package.
  passthru.pharHash = "sha256-cmACAcc8fEshjxwFEbNthTeWPjaq+iRHV/UjCfiFsxQ=";

  composer = callPackage ../../../build-support/php/pkgs/composer-phar.nix {
    inherit (finalAttrs) version;
    inherit (finalAttrs.passthru) pharHash;
  };

  pname = "composer";
  version = "2.6.6";

  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    rev = finalAttrs.version;
    hash = "sha256-KsTZi7dSlQcAxoen9rpofbptVdLYhK+bZeDSXQY7o5M=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2024-24821.patch";
      url = "https://github.com/composer/composer/commit/77e3982918bc1d886843dc3d5e575e7e871b27b7.patch";
      hash = "sha256-Q7gkPLf59+p++DpfJZeOrAOiWePuGkdGYRaS/rK+Nv4=";
      excludes = [
        # Skipping test files, they are not included in the source tarball
        "tests/*"
      ];
    })
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/composer \
      --prefix PATH : ${lib.makeBinPath [ _7zz cacert curl git unzip xz ]}
  '';

  vendorHash = "sha256-50M1yeAKl9KRsjs34cdb5ZTBFgbukgg0cMtHTYGJ/EM=";

  meta = {
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    description = "Dependency Manager for PHP";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    mainProgram = "composer";
    maintainers = lib.teams.php.members;
  };
})
