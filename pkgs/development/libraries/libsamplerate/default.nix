{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsamplerate-0.1.7";

  src = fetchurl {
    url = "http://www.mega-nerd.com/SRC/${name}.tar.gz";
    sha256 = "1m1iwzpcny42kcqv5as2nyb0ggrb56wzckpximqpp2y74dipdf4q";
  };

  # maybe interesting configure flags:
  #--disable-fftw          disable usage of FFTW
  #--disable-cpu-clip      disable tricky cpu specific clipper

  configurePhase =
    ''
      export LIBSAMPLERATE_CFLAGS="-I $libsamplerate/include"
      export LIBSAMPLERATE_LIBS="-L $libsamplerate/libs"
      ./configure --prefix=$out
    '';

  meta = {
    description = "Sample Rate Converter for audio";
    homepage = http://www.mega-nerd.com/SRC/index.html;
    # you can choose one of the following licenses:
    license = [
      "GPL"
      # http://www.mega-nerd.com/SRC/libsamplerate-cul.pdf
      "libsamplerate Commercial Use License"
    ];
  };
}
