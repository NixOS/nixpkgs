{
  buildMix,
  fetchFromGitHub,
  lib,
}:

buildMix (finalAttrs: {
  name = "hex";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "hexpm";
    repo = "hex";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ckqHN6SCFOKZd9XBxMQB/qzt0g6cCYMm1gA0LYtKsHE=";
  };

  # this is hex, avoid recursion
  enableHex = false;

  meta = {
    description = "Package manager for the Erlang VM";
    homepage = "https://github.com/hexpm/hex";
    changelog = "https://github.com/hexpm/hex/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ericbmerritt ];
    teams = [ lib.teams.beam ];
  };
})
