{
  lib,
  fetchFromGitHub,
  php,
}:

let
  version = "1.1.0";
in
php.buildComposerWithPlugin {
  pname = "nix-community/composer-local-repo-plugin";
  inherit version;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "composer-local-repo-plugin";
    rev = version;
    hash = "sha256-edbn07r/Uc1g0qOuVBZBs6N1bMN5kIfA1b4FCufdw5M=";
  };

  composerLock = ./composer.lock;
<<<<<<< HEAD
  vendorHash = "sha256-cup8maS9NkhdqTHoKJaH7r7AJQdkflWTvM6uIuxMPX0=";
=======
  vendorHash = "sha256-SL3HiYTVaUwcEfnRO932MWgOP1VRkxTl3lxLbW0qiTY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    changelog = "https://github.com/nix-community/composer-local-repo-plugin/releases/tag/${version}";
    description = "Composer plugin that facilitates the creation of a local composer type repository";
    homepage = "https://github.com/nix-community/composer-local-repo-plugin";
    license = lib.licenses.mit;
    mainProgram = "composer";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
