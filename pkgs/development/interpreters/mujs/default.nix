{ stdenv, fetchgit, clang }:

stdenv.mkDerivation rec {
  name = "mujs-2016-02-22";

  src = fetchgit {
    url = git://git.ghostscript.com/mujs.git;
    rev  = "624f975aae6b451e35406d8cdde808626052ce2c";
    sha256 = "0vaskzpi84g56yjfkfri1r0lbkawhn556v0b69xjfls7ngsw346y";
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
