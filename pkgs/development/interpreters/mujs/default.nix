{ stdenv, fetchgit, clang }:

stdenv.mkDerivation rec {
  name = "mujs-2014-11-29";

  src = fetchgit {
    url = git://git.ghostscript.com/mujs.git;
    rev  = "9bc5fec0804381d59ef8dc62304ed6892fb7c4ca";
    sha256 = "0ba6p92ygcssfzd4ij89vilfr2kwql2d1jpyqxflh5wyh1i92wjl";
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
