{ lib, php, fetchFromGitHub }:

php.buildComposerProject (finalAttrs: {
  pname = "box";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "box-project";
    repo = "box";
    rev = finalAttrs.version;
    hash = "sha256-3YfnFd8OZ15nQnXOkhNz2FQygElFn+JOrenKUeyTkXA=";
  };

  vendorHash = "sha256-0ul4NLGK+Z+VN1nv4xSGsh2JcJEXeYAYFhxDn7r3kVY=";

  meta = {
    changelog = "https://github.com/box-project/box/releases/tag/${finalAttrs.version}";
    description = "An application for building and managing Phars";
    homepage = "https://github.com/box-project/box";
    license = lib.licenses.mit;
    mainProgram = "box";
    maintainers = lib.teams.php.members;
  };
})
