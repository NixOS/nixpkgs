{ fetchurl, stdenv
, withOctave ? true, octave ? null}:

stdenv.mkDerivation rec {
  name = "nlopt-2.3";

  src = fetchurl {
    url = "http://ab-initio.mit.edu/nlopt/${name}.tar.gz";
    sha256 = "1iw2cjgypyqz779f47fz0nmifbrvk4zs4rxi1ibk36f4ly3wg6p6";
  };

  buildInputs = stdenv.lib.optional withOctave octave;

  configureFlags = "--with-cxx --enable-shared --with-pic --without-guile --without-python
  --without-matlab " +
    stdenv.lib.optionalString withOctave ("--with-octave " +
        "M_INSTALL_DIR=$(out)/${octave.sitePath}/m " +
        "OCT_INSTALL_DIR=$(out)/${octave.sitePath}/oct ");
}
