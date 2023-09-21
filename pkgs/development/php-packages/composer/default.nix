{ lib, callPackage, fetchFromGitHub, php, unzip, _7zz, xz, git, curl, cacert, makeBinaryWrapper }:

php.buildComposerProject (finalAttrs: {
  composer = callPackage ../../../build-support/php/pkgs/composer-phar.nix { };

  pname = "composer";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    rev = finalAttrs.version;
    hash = "sha256-yzpkdtfok22yMvRdv4jYrd8x8MgNZbSDOsg+sVl/JqE=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/composer \
      --prefix PATH : ${lib.makeBinPath [ _7zz cacert curl git unzip xz ]}
  '';

  vendorHash = "sha256-SG5RsKaP7zqJY2vjvULuNdf7w6tAGh7/dlxx2Pkfj2A=";

  meta = {
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    description = "Dependency Manager for PHP";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
