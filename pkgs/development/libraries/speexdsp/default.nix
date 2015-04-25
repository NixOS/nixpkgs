{ stdenv, fetchurl, autoreconfHook, pkgconfig, fftw }:

stdenv.mkDerivation rec {
  name = "speexdsp-1.2rc3";
  
  src = fetchurl {
    url = "http://downloads.us.xiph.org/releases/speex/${name}.tar.gz";
    sha256 = "1wcjyrnwlkayb20zdhp48y260rfyzg925qpjpljd5x9r01h8irja";
  };

  patches = [ ./build-fix.patch ];
  
  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ fftw ];

  configureFlags = [
    "--with-fft=gpl-fftw3"
  ];

  meta = with stdenv.lib; {
    hompage = http://www.speex.org/;
    description = "an Open Source/Free Software patent-free audio compression format designed for speech";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
