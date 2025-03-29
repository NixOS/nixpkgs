{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "webwormhole";
  version = "0-unstable-2023-11-15";

  src = fetchFromGitHub {
    owner = "saljam";
    repo = pname;
    rev = "6ceee76274ee881e828bd48c5cc15c758b9ad77c";
    hash = "sha256-C9r6wFhP5BkIClgTQol7LyMUHXOzyrX9Pn91VqBaqFQ=";
  };

  vendorHash = "sha256-+7ctAm2wnjmfMd6CHXlcAUwiUMS7cH4koDAvlEUAXEg=";

  meta = with lib; {
    description = "Send files using peer authenticated WebRTC";
    homepage = "https://github.com/saljam/webwormhole";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bbigras ];
    mainProgram = "ww";
  };
}
