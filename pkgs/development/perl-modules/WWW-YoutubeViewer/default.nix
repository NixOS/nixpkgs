{
  stdenv,
  lib,
  fetchFromGitHub,
  buildPerlPackage,
  LWP,
  LWPProtocolHttps,
  DataDump,
  JSON,
  gitUpdater,
}:

buildPerlPackage rec {
  pname = "WWW-YoutubeViewer";
  version = "3.11.2";

  src = fetchFromGitHub {
    owner = "trizen";
    repo = "youtube-viewer";
    rev = version;
    sha256 = "9Z4fv2B0AnwtYsp7h9phnRMmHtBOMObIJvK8DmKQRxs=";
  };

  propagatedBuildInputs = [
    LWP
    LWPProtocolHttps
    DataDump
    JSON
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Lightweight application for searching and streaming videos from YouTube";
    homepage = "https://github.com/trizen/youtube-viewer";
    license = with lib.licenses; [ artistic2 ];
    maintainers = with lib.maintainers; [ woffs ];
    mainProgram = "youtube-viewer";
  };
}
