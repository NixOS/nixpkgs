{ stdenv, lib, fetchFromGitHub, buildPerlPackage, shortenPerlShebang, LWP, LWPProtocolHttps, DataDump, JSON }:

buildPerlPackage rec {
  pname = "WWW-YoutubeViewer";
  version = "3.7.9";

  src = fetchFromGitHub {
    owner  = "trizen";
    repo   = "youtube-viewer";
    rev    = version;
    sha256 = "16p0sa91h0zpqdpqmy348g6b9qj5f6qrbzrljn157vk00cg6mx18";
  };

  nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
  propagatedBuildInputs = [
    LWP
    LWPProtocolHttps
    DataDump
    JSON
  ];
  postInstall = lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/youtube-viewer
  '';

  meta = with lib; {
    description = "A lightweight application for searching and streaming videos from YouTube";
    homepage = "https://github.com/trizen/youtube-viewer";
    license = with licenses; [ artistic2 ];
    maintainers = with maintainers; [ woffs ];
    mainProgram = "youtube-viewer";
  };
}
