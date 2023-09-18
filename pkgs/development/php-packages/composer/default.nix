{ lib, callPackage, fetchFromGitHub, php, unzip, _7zz, xz, git, curl, cacert, makeBinaryWrapper }:

php.buildComposerProject (finalAttrs: {
  composer = callPackage ../../../build-support/php/pkgs/composer-phar.nix { };

  pname = "composer";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    rev = finalAttrs.version;
    hash = "sha256-tNc0hP41aRk7MmeWXCd73uHxK9pk1tCWyjiSO568qbE=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/composer \
      --prefix PATH : ${lib.makeBinPath [ _7zz cacert curl git unzip xz ]}
  '';

  vendorHash = "sha256-V6C4LxEfXNWH/pCKATv1gf8f6/a0s/xu5j5bNJUNmnA=";

  meta = {
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    description = "Dependency Manager for PHP";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
