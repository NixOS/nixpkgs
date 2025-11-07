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
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "ziinaio";
    repo = "zmate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7RDcRu41zyYIEwQ3wghesTbGAp6sqe44/sFZTzMqpNA=";
  };

  vendorHash = "sha256-o4RQ2feBP/qt7iv8jUb1zyHJzurjqh+dW3W5qjEuO1o=";

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
