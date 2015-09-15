{ stdenv, fetchgit, clang }:

stdenv.mkDerivation rec {
  name = "mujs-2015-09-15";

  src = fetchgit {
    url = git://git.ghostscript.com/mujs.git;
    rev  = "17019d29e5494d4b0ae148a3043a940be78e3215";
    sha256 = "07192f4va733dr3v4ywfaqhz21iyydjwm84ij7zafwjvfi5z2b38";
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
