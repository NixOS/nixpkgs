{ stdenv, fetchurl, autoreconfHook, pkgconfig, fftw, speexdsp }:

stdenv.mkDerivation rec {
  name = "speex-1.2rc2";

  src = fetchurl {
    url = "http://downloads.us.xiph.org/releases/speex/${name}.tar.gz";
    sha256 = "14g8ph39inkrif749lzjm089g7kwk0hymq1a3i9ch5gz8xr7r8na";
  };

  postPatch = ''
    sed -i '/AC_CONFIG_MACRO_DIR/i PKG_PROG_PKG_CONFIG' configure.ac
  '';

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ fftw speexdsp ];

  # TODO: Remove this will help with immediate backward compatability
  propagatedBuildInputs = [ speexdsp ];

  configureFlags = [
    "--with-fft=gpl-fftw3"
  ];

  meta = with stdenv.lib; {
    hompage = http://www.speex.org/;
    description = "An Open Source/Free Software patent-free audio compression format designed for speech";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
