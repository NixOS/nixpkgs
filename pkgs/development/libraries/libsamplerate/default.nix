{ stdenv, fetchurl, pkgconfig, fftw, libsndfile }:

stdenv.mkDerivation rec {
  name = "libsamplerate-0.1.7";

  src = fetchurl {
    url = "http://www.mega-nerd.com/SRC/${name}.tar.gz";
    sha256 = "1m1iwzpcny42kcqv5as2nyb0ggrb56wzckpximqpp2y74dipdf4q";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ fftw libsndfile ];

  # maybe interesting configure flags:
  #--disable-fftw          disable usage of FFTW
  #--disable-cpu-clip      disable tricky cpu specific clipper

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
