{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  zellij,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "zmate";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "ziinaio";
    repo = "zmate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NQIHnFyQvRVQxCHBEgSxCMa91d6qeMUe+i8zxB5aO1Q=";
  };

  vendorHash = "sha256-yT96OL0hUAU6uBR5Du2p2vSG6q9wjWlP5QBOhGk+Xl4=";

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/zmate \
      --suffix PATH ":" ${
        lib.makeBinPath [
          zellij
        ]
      }
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Instant terminal sharing using Zellij";
    mainProgram = "zmate";
    homepage = "https://github.com/ziinaio/zmate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lykos153 ];
  };
})
