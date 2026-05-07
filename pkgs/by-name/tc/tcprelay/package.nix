{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "tcprelay";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "overhead";
    repo = "tcp-relay";
    rev = "v${version}";
    hash = "sha256-GmYIkUBPjxKDhVlrEIFX3s0DacIoOtQWM67gkXV1H/Q=";
  };

  vendorHash = null;
  __structuredAttrs = true;

  meta = with lib; {
    description = "TCP relay written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ shutdaun ];
    mainProgram = "tcprelay";
    platforms = platforms.all;
  };
}
