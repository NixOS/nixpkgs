{ stdenv, fetchurl, unzip, tcl }:

let
  archiveVersion = import ./archive-version.nix stdenv.lib;
in

stdenv.mkDerivation rec {
  pname = "sqldiff";
  version = import ./version.nix;

  src = fetchurl {
    url = "https://sqlite.org/2020/sqlite-src-${archiveVersion version}.zip";
    sha256 = "0n7f3w59gr80s6k4l5a9bp2s97dlfapfbhb3qdhak6axhn127p7j";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ tcl ];

  makeFlags = [ "sqldiff" ];

  installPhase = "install -Dt $out/bin sqldiff";

  meta = with stdenv.lib; {
    description = "A command-line utility program that displays the differences between SQLite databases";
    downloadPage = "http://sqlite.org/download.html";
    homepage = "https://www.sqlite.org";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ markus1189 ];
    platforms = platforms.unix;
  };
}
