{ stdenv, fetchgit, clang }:

stdenv.mkDerivation rec {
  name = "mujs-2015-01-22";

  src = fetchgit {
    url = git://git.ghostscript.com/mujs.git;
    rev  = "c1ad1ba1e482e7d01743e3f4f9517572bebf99ac";
    sha256 = "1713h82zzd189nb54ilpa8fj9xhinhn0jvmd3li4c2fwh6xfjpcy";
  };

  buildInputs = [ clang ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = http://mujs.com/;
    description = "A lightweight, embeddable Javascript interpreter";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ pSub ];
    license = licenses.gpl3;
  };
}
