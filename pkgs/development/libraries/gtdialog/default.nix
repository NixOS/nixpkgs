{stdenv, fetchurl, cdk, unzip, gtk2, glib, ncurses, pkgconfig}:
let
  s = # Generated upstream information
  rec {
    baseName="gtdialog";
    version="1.4";
    name="${baseName}-${version}";
    hash="1lhsaz56s8m838fi6vnfcd2r6djymvy3n2pbqhii88hraapq3rfk";
    url="https://foicica.com/gtdialog/download/gtdialog_1.4.zip";
    sha256="1lhsaz56s8m838fi6vnfcd2r6djymvy3n2pbqhii88hraapq3rfk";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cdk unzip gtk2 glib ncurses
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit nativeBuildInputs buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  makeFlags = ["PREFIX=$(out)"];
  meta = {
    inherit (s) version;
    description = ''Cross-platform helper for creating interactive dialogs'';
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "http://foicica.com/gtdialog";
    downloadPage = "http://foicica.com/gtdialog/download";
  };
}
