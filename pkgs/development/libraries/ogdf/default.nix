{ stdenv, fetchFromGitHub, cmake, doxygen }:

stdenv.mkDerivation rec {
  pname = "ogdf";
  version = "2020.02";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "catalpa-202002";
    sha256 = "0drrs8zh1097i5c60z9g658vs9k1iinkav8crlwk722ihfm1vxqd";
  };

  nativeBuildInputs = [ cmake doxygen ];

  cmakeFlags = [ "-DCMAKE_CXX_FLAGS=-fPIC" ];

  # Without disabling hardening for format, the build fails with
  # the following error.
  #> /build/source/src/coin/CoinUtils/CoinMessageHandler.cpp:766:35: error: format not a string literal and no format arguments [-Werror=format-security]
  #> 766 |      sprintf(messageOut_,format_+2);
  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "Open Graph Drawing Framework/Open Graph algorithms and Data structure Framework";
    homepage = "http://www.ogdf.net";
    license = licenses.gpl2;
    maintainers = [ maintainers.ianwookim ];
    platforms = platforms.i686 ++ platforms.x86_64;
    longDescription = ''
      OGDF stands both for Open Graph Drawing Framework (the original name) and
      Open Graph algorithms and Data structures Framework.

      OGDF is a self-contained C++ library for graph algorithms, in particular
      for (but not restricted to) automatic graph drawing. It offers sophisticated
      algorithms and data structures to use within your own applications or
      scientific projects.

      OGDF is developed and supported by Osnabrück University, TU Dortmund,
      University of Cologne, University of Konstanz, and TU Ilmenau.
    '';
   };
}
