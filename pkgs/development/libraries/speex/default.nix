{ stdenv, fetchurl, autoreconfHook, pkgconfig, fftw, speexdsp }:

stdenv.mkDerivation rec {
  name = "speex-1.2.0";

  src = fetchurl {
    url = "http://downloads.us.xiph.org/releases/speex/${name}.tar.gz";
    sha256 = "150047wnllz4r94whb9r73l5qf0z5z3rlhy98bawfbblmkq8mbpa";
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
    homepage = https://www.speex.org/;
    description = "An Open Source/Free Software patent-free audio compression format designed for speech";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
