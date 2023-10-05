{ lib, callPackage, fetchgit, php, unzip, _7zz, xz, git, curl, cacert, makeBinaryWrapper }:

php.buildComposerProject (finalAttrs: {
  composer = callPackage ../../../build-support/php/pkgs/composer-phar.nix { };

  pname = "composer";
  version = "2.6.4";


  # We use `fetchgit` instead of `fetchFromGitHub` to ensure the existence
  # of the `composer.lock` file, which is omitted in the archive downloaded
  # via `fetchFromGitHub`.
  src = fetchgit {
    url = "https://github.com/composer/composer.git";
    rev = finalAttrs.version;
    hash = "sha256-8lylMfTARff+gBZpIRqttmE0jeXdJnLHZKVmqHY3p+s=";
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
