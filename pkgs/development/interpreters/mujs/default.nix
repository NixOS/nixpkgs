{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "mujs-${version}";
  version = "1.0.6";

  src = fetchurl {
    url = "https://mujs.com/downloads/mujs-${version}.tar.xz";
    sha256 = "1q9w2dcspfp580pzx7sw7x9gbn8j0ak6dvj75wd1ml3f3q3i43df";
  };

  buildInputs = [ readline ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://mujs.com/;
    description = "A lightweight, embeddable Javascript interpreter";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
    license = licenses.gpl3;
  };
}
