{ stdenv, version, src
, liboggSupport ? true, libogg ? null # if disabled only the library will be built
, prePatch ? ""
, ...
}:

# The celt codec has been deprecated and is now a part of the opus codec

stdenv.mkDerivation rec {
  pname = "celt";
  inherit version;

  inherit src;

  inherit prePatch;

  buildInputs = []
    ++ stdenv.lib.optional liboggSupport libogg;

  doCheck = false; # fails

  meta = with stdenv.lib; {
    description = "Ultra-low delay audio codec";
    homepage    = http://www.celt-codec.org/;
    license     = licenses.bsd2;
    maintainers = with maintainers; [ codyopel raskin ];
    platforms   = platforms.unix;
  };
}
