{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phing";
  version = "3.0.0-RC4";

  src = fetchFromGitHub {
    owner = "phingofficial";
    repo = "phing";
    rev = finalAttrs.version;
    hash = "sha256-qaduCfAWVgqQFNmuH3nxqtv92RWdXY0g40oVlh88zyE=";
  };

  # TODO: Open a PR against https://github.com/phingofficial/phing
  # Their `composer.lock` is out of date therefore, we need to provide one
  composerLock = ./composer.lock;
  vendorHash = "sha256-Y8QDQrpfKkAxERpl8/HccGghlmJnkHcU8VAIFWZNQCU=";

  meta = with lib; {
    description = "PHing Is Not GNU make; it's a PHP project build system or build tool based on Apache Ant";
    license = licenses.lgpl3;
    homepage = "https://github.com/phingofficial/phing";
    maintainers = teams.php.members;
  };
})
