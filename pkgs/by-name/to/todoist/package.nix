{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "todoist";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Q3sqgqN4xUGeVmncEAGDker6tau8h30zBPEjgLSxazI=";
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
