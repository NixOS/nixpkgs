{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phing";
  version = "3.0.0-rc5";

  src = fetchFromGitHub {
    owner = "phingofficial";
    repo = "phing";
    rev = finalAttrs.version;
    hash = "sha256-g9AKzAl4xO3ax7FNWvh0sqTea6Txapky5Tp7YT5L8ZQ=";
  };

  # TODO: Open a PR against https://github.com/phingofficial/phing
  # Their `composer.lock` is out of date therefore, we need to provide one
  composerLock = ./composer.lock;
  vendorHash = "sha256-6jre6JfKh22Ga0wXDIQNf/NIh0syHmrFtianvluHdyI=";

  meta = with lib; {
    description = "PHing Is Not GNU make; it's a PHP project build system or build tool based on Apache Ant";
    license = licenses.lgpl3;
    homepage = "https://github.com/phingofficial/phing";
    maintainers = teams.php.members;
  };
})
