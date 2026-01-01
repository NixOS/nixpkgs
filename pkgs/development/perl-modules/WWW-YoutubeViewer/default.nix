{
  stdenv,
  lib,
  fetchFromGitHub,
  buildPerlPackage,
<<<<<<< HEAD
=======
  shortenPerlShebang,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
=======
  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin shortenPerlShebang;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  propagatedBuildInputs = [
    LWP
    LWPProtocolHttps
    DataDump
    JSON
  ];
<<<<<<< HEAD

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Lightweight application for searching and streaming videos from YouTube";
    homepage = "https://github.com/trizen/youtube-viewer";
    license = with lib.licenses; [ artistic2 ];
    maintainers = with lib.maintainers; [ woffs ];
=======
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    shortenPerlShebang $out/bin/youtube-viewer
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Lightweight application for searching and streaming videos from YouTube";
    homepage = "https://github.com/trizen/youtube-viewer";
    license = with licenses; [ artistic2 ];
    maintainers = with maintainers; [ woffs ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "youtube-viewer";
  };
}
