{
  lib,
  buildGoModule,
  fetchFromGitLab,
  finalAttrs ? { },
}:

buildGoModule {
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
    description = "TCP relay written in Go";
    homepage = "https://gitlab.com/overhead/tcp-relay";
    changelog = "";
    license = licenses.mit;
    maintainers = with maintainers; [ shutdaun ];
    mainProgram = "tcprelay";
    platforms = platforms.all;
  };
}
