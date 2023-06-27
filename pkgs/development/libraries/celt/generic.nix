{ lib, stdenv, version, src
, liboggSupport ? true, libogg ? null # if disabled only the library will be built
, prePatch ? ""
, ...
}:

# The celt codec has been deprecated and is now a part of the opus codec

stdenv.mkDerivation {
  pname = "celt";
  inherit version;

  inherit src;

  outputs = [ "out" "dev" ];

  inherit prePatch;

  buildInputs = []
    ++ lib.optional liboggSupport libogg;

  doCheck = false; # fails

  meta = with lib; {
    description = "Ultra-low delay audio codec";
    homepage    = "https://gitlab.xiph.org/xiph/celt"; # http://www.celt-codec.org/ is gone
    license     = licenses.bsd2;
    maintainers = with maintainers; [ codyopel raskin ];
    platforms   = platforms.unix;
  };
}
