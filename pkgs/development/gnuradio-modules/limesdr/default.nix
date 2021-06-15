{ lib
, mkDerivation
, fetchFromGitHub
, gnuradio
, cmake
, pkg-config
, doxygen
, swig
, python
, log4cpp
, mpir
, boost
, gmp
, icu
, limesuite
}:

let
  version = {
    "3.7" = "2.0.0";
    "3.8" = "3.0.1";
    "3.9" = null;
  }.${gnuradio.versionAttr.major};
  src = fetchFromGitHub {
    owner = "myriadrf";
    repo = "gr-limesdr";
    rev = "v${version}";
    sha256 = {
      "3.7" = "0ldqvfwl0gil89l9s31fjf9d7ki0dk572i8vna336igfaz348ypq";
      "3.8" = "ffs+8TU0yr6IW1xZJ/abQ1CQWGZM+zYqPRJxy3ZvM9U=";
      "3.9" = null;
    }.${gnuradio.versionAttr.major};
  };
in mkDerivation {
  pname = "gr-limesdr";
  inherit version src;
  disabledForGRafter = "3.9";

  nativeBuildInputs = [
    cmake
    pkg-config
    swig
    python
  ];
  buildInputs = [
    log4cpp
    mpir
    boost
    gmp
    icu
    limesuite
  ];

  meta = with lib; {
    description = "Gnuradio source and sink blocks for LimeSDR";
    homepage = "https://wiki.myriadrf.org/Gr-limesdr_Plugin_for_GNURadio";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.markuskowa ];
  };
}
