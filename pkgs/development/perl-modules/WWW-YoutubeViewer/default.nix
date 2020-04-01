{ stdenv, fetchFromGitHub, buildPerlPackage, shortenPerlShebang, LWP, LWPProtocolHttps, DataDump, JSON }:

buildPerlPackage rec {
  pname = "WWW-YoutubeViewer";
  version = "3.7.5";

  src = fetchFromGitHub {
    owner  = "trizen";
    repo   = "youtube-viewer";
    rev    = version;
    sha256 = "1caz56sxy554avz2vdv9gm7gyqcq0gyixzrh5v9ixmg6vxif5d4f";
  };

  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin shortenPerlShebang;
  propagatedBuildInputs = [
    LWP
    LWPProtocolHttps
    DataDump
    JSON
  ];
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/youtube-viewer
  '';

  meta = {
    description = "A lightweight application for searching and streaming videos from YouTube";
    homepage = "https://github.com/trizen/youtube-viewer";
    maintainers = with stdenv.lib.maintainers; [ woffs ];
    license = with stdenv.lib.licenses; [ artistic2 ];
  };
}
