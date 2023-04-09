{ fetchFromGitHub, lib, php }:

php.buildComposerProject (finalAttrs: {
  pname = "box";
  version = "4.3.8";

  src = fetchFromGitHub {
    owner = "box-project";
    repo = "box";
    rev = finalAttrs.version;
    hash = "sha256-v1J84nqaX36DrLLH5kld+8NIymqtt5/5nJWJNCBVFRE=";
  };

  php = php.buildEnv {
    extraConfig = ''
      phar.readonly=0
    '';
  };

  vendorHash = "sha256-iFb+x5pUsrkM9IpgjwbEA1V3wOQGvFpIWiwb9sCf0hA=";

  meta = {
    changelog = "https://github.com/box-project/box/releases/tag/${finalAttrs.version}";
    description = "An application for building and managing Phars";
    homepage = "https://github.com/box-project/box";
    license = lib.licenses.mit;
    maintainers = lib.teams.php.members;
  };
})
