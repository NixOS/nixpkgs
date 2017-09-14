{stdenv, fetchurl, cdk, unzip, gtk2, glib, ncurses, pkgconfig}:
let
  s = # Generated upstream information
  rec {
    baseName="gtdialog";
    version="1.3";
    name="${baseName}-${version}";
    hash="0y7sln877940bpj0s38cs5s97xg8csnaihh18lmnchf7c2kkbxpq";
    url="http://foicica.com/gtdialog/download/gtdialog_1.3.zip";
    sha256="0y7sln877940bpj0s38cs5s97xg8csnaihh18lmnchf7c2kkbxpq";
  };
  buildInputs = [
    cdk unzip gtk2 glib ncurses pkgconfig
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
    homepage = http://foicica.com/gtdialog;
    downloadPage = "http://foicica.com/gtdialog/download";
  };
}
