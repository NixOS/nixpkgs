{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "todoist";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+W6pc6J5eK/Sg7rc/6XJQtQ2IwVjyF/GbCX8+88k4Gc=";
  };

  vendorHash = "sha256-eVB5k/Z5Z6SsPqySPm4xZIh07c9xbijImRk8zdvY6tA=";

  doCheck = false;

  meta = {
    homepage = "https://github.com/sachaos/todoist";
    description = "Todoist CLI Client";
    license = lib.licenses.mit;
    mainProgram = "todoist";
  };
})
