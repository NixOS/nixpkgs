{ fetchurl, stdenv, octave ? null }:

stdenv.mkDerivation rec {
  name = "nlopt-2.4.2";

  src = fetchurl {
    url = "http://ab-initio.mit.edu/nlopt/${name}.tar.gz";
    sha256 = "12cfkkhcdf4zmb6h7y6qvvdvqjs2xf9sjpa3rl3bq76px4yn76c0";
  };

  buildInputs = [ octave ];

  configureFlags = "--with-cxx --enable-shared --with-pic --without-guile --without-python
  --without-matlab " +
    stdenv.lib.optionalString (octave != null) ("--with-octave " +
        "M_INSTALL_DIR=$(out)/${octave.sitePath}/m " +
        "OCT_INSTALL_DIR=$(out)/${octave.sitePath}/oct ");

  preConfigure = ''
    find octave -name '*.cc' | xargs sed -i 's|Octave_map|octave_map|g'
  '';

  meta = {
    homepage = "http://ab-initio.mit.edu/nlopt/";
    description = "Free open-source library for nonlinear optimization";
    license = stdenv.lib.licenses.lgpl21Plus;
    hydraPlatforms = stdenv.lib.platforms.linux;
    broken = true;              # cannot cope with Octave 4.x
  };

}
