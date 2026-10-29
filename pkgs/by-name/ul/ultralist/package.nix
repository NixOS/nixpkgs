{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ultralist";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "ultralist";
    repo = "ultralist";
    rev = finalAttrs.version;
    sha256 = "sha256-GGBW6rpwv1bVbLTD//cU8jNbq/27Ls0su7DymCJTSmY=";
  };

  vendorHash = null;

  meta = {
    description = "Simple GTD-style todo list for the command line";
    homepage = "https://ultralist.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uvnikita ];
    mainProgram = "ultralist";
  };
})
