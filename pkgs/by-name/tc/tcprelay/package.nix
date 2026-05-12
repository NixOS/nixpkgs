{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule (finalAttrs: {
  pname = "tcprelay";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "overhead";
    repo = "tcp-relay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GmYIkUBPjxKDhVlrEIFX3s0DacIoOtQWM67gkXV1H/Q=";
  };

  vendorHash = null;
  __structuredAttrs = true;

  meta = with lib; {
    description = "TCP traffic relay written in Go";
    homepage = "https://gitlab.com/overhead/tcp-relay";
    changelog = "https://gitlab.com/overhead/tcp-relay/-/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ shutdaun ];
    mainProgram = "tcprelay";
    platforms = platforms.linux;
  };
})
