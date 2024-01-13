{ lib, php82, fetchFromGitHub }:

php82.buildComposerProject (finalAttrs: {
  pname = "box";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "box-project";
    repo = "box";
    rev = finalAttrs.version;
    hash = "sha256-s3FnpfKWmsLLXwa/xI80NZ1030fB9LcrMVzNWGeFkn4=";
  };

  vendorHash = "sha256-t1DvlcgTSq4n8xVUMcEIfs5ZAq9XIqL3qUqabheVVrs=";

  meta = {
    changelog = "https://github.com/box-project/box/releases/tag/${finalAttrs.version}";
    description = "An application for building and managing Phars";
    homepage = "https://github.com/box-project/box";
    license = lib.licenses.mit;
    mainProgram = "box";
    maintainers = lib.teams.php.members;
  };
})
