{ stdenv, fetchgit, clang }:

stdenv.mkDerivation rec {
  name = "mujs-2016-11-30";

  src = fetchgit {
    url = git://git.ghostscript.com/mujs.git;
    rev  = "a0ceaf5050faf419401fe1b83acfa950ec8a8a89";
    sha256 = "13abghhqrivaip4h0fav80i8hid220dj0ddc1xnhn6w9rbnrriyg";
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
