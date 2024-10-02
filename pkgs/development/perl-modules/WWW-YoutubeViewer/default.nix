{
  stdenv,
  lib,
  fetchFromGitHub,
  buildPerlPackage,
  shortenPerlShebang,
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

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin shortenPerlShebang;
  propagatedBuildInputs = [
    LWP
    LWPProtocolHttps
    DataDump
    JSON
  ];
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    shortenPerlShebang $out/bin/youtube-viewer
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Lightweight application for searching and streaming videos from YouTube";
    homepage = "https://github.com/trizen/youtube-viewer";
    license = with licenses; [ artistic2 ];
    maintainers = with maintainers; [ woffs ];
    mainProgram = "youtube-viewer";
  };
}
