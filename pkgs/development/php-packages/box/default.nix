{ lib, php, fetchFromGitHub }:

php.buildComposerProject (finalAttrs: {
  pname = "box";
  version = "4.3.8";

  src = fetchFromGitHub {
    owner = "box-project";
    repo = "box";
    rev = finalAttrs.version;
    hash = "sha256-v1J84nqaX36DrLLH5kld+8NIymqtt5/5nJWJNCBVFRE=";
  };

  vendorHash = "sha256-LWggAUBMKljxa7HNdJMqOD/sx3IWCOQSqbYEnGntjN0=";

  meta = {
    changelog = "https://github.com/box-project/box/releases/tag/${finalAttrs.version}";
    description = "An application for building and managing Phars";
    license = lib.licenses.mit;
    homepage = "https://github.com/box-project/box";
    maintainers = lib.teams.php.members;
    mainProgram = "box";
  };
})
