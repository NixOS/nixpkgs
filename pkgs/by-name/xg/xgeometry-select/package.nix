{ lib, stdenv, fetchurl, libX11 }:

stdenv.mkDerivation rec {
  pname = "xgeometry-select";
  version  = "0.1";

  src = fetchurl {
    url    = "https://gist.githubusercontent.com/obadz/7e008b1f803c4cdcfaf7321c78bcbe92/raw/7e7361e71ff0f74655ee92bd6d2c042f8586f2ae/xgeometry-select.c";
    sha256 = "0s7kirgh5iz91m3qy8xiq0j4gljy8zrcnylf4szl5h0lrsaqj7ya";
  };

  dontUnpack = true;

  buildInputs = [ libX11 ];

  buildPhase = ''
    gcc -Wall -lX11 ${src} -o xgeometry-select
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv -v xgeometry-select $out/bin
  '';

  meta = with lib; {
    description = "Select a region with mouse and prints geometry information (x/y/w/h)";
    homepage    = "https://bbs.archlinux.org/viewtopic.php?pid=660837";
    maintainers = with maintainers; [ obadz ];
    platforms   = platforms.linux;
    mainProgram = "xgeometry-select";
  };
}
