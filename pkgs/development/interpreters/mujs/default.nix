{ stdenv, fetchgit, clang }:

stdenv.mkDerivation rec {
  name = "mujs-2015-09-29";

  src = fetchgit {
    url = git://git.ghostscript.com/mujs.git;
    rev  = "08276111f575ac6142e922d62aa264dc1f30b69e";
    sha256 = "18w7yayrn5p8amack4p23wcz49x9cjh1pmzalrf16fhy3n753hbb";
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
