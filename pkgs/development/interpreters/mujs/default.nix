{ stdenv, fetchgit, clang }:

stdenv.mkDerivation rec {
  name = "mujs-2016-09-21";

  src = fetchgit {
    url = git://git.ghostscript.com/mujs.git;
    rev  = "5c337af4b3df80cf967e4f9f6a21522de84b392a";
    sha256 = "1x5g6nycggc83md2dbr2nahjbkkmmn64bg25a8hih7z72sw41dgw";
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
