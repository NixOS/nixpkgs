{
  buildMix,
  cacert,
  fetchFromGitHub,
  lib,
}:

buildMix (finalAttrs: {
  name = "hex";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "hexpm";
    repo = "hex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-13WsOshHhGK+Df/Lr6GqaOFvttcLrk7cbTS1NsQXMvY=";
  };

  # Hex must bootstrap without depending on itself.
  enableHex = false;

  postPatch = ''
    cp ${cacert}/etc/ssl/certs/ca-bundle.crt lib/hex/http/ca-bundle.crt
  '';

  meta = {
    description = "Package manager for the Erlang VM";
    homepage = "https://github.com/hexpm/hex";
    changelog = "https://github.com/hexpm/hex/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ericbmerritt ];
    teams = [ lib.teams.beam ];
  };
})
