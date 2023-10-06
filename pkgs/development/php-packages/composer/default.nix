{ lib, callPackage, fetchFromGitHub, php, unzip, _7zz, xz, git, curl, cacert, makeBinaryWrapper }:

php.buildComposerProject (finalAttrs: {
  composer = callPackage ../../../build-support/php/pkgs/composer-phar.nix { };

  pname = "composer";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    rev = finalAttrs.version;
    hash = "sha256-o7z2GBiYjTwDQR9ZFuOOV8zsKUuGqyA52dvwTzo4hVA=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/composer \
      --prefix PATH : ${lib.makeBinPath [ _7zz cacert curl git unzip xz ]}
  '';

  vendorHash = "sha256-S6LprixkLIbD+qqvg+eYjWsDe+jFl9NO1qWztWYKPXs=";

  meta = {
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    description = "Dependency Manager for PHP";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
