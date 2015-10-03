{stdenv, fetchurl, cdk, unzip, gtk, glib, ncurses, pkgconfig}:
let
  s = # Generated upstream information
  rec {
    baseName="gtdialog";
    version="1.2";
    name="${baseName}-${version}";
    hash="0nvcldyhj8abr8jny9pbyfjwg8qfp9f2h508vjmrvr5c5fqdbbm0";
    url="http://foicica.com/gtdialog/download/gtdialog_1.2.zip";
    sha256="0nvcldyhj8abr8jny9pbyfjwg8qfp9f2h508vjmrvr5c5fqdbbm0";
  };
  buildInputs = [
    cdk unzip gtk glib ncurses pkgconfig
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
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
