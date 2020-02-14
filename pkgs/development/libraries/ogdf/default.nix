{ stdenv, fetchFromGitHub, cmake, doxygen }:

stdenv.mkDerivation rec {
  name = "ogdf-${version}";
  version = "2020.02";
  src = fetchFromGitHub {
    owner = "ogdf";
    repo = "ogdf";
    rev = "be4452b6c36575d11a04d5bb1b362edeb8173eaa";
    sha256 = "0drrs8zh1097i5c60z9g658vs9k1iinkav8crlwk722ihfm1vxqd";
  };

  hardeningDisable = [ "all" ];
  nativeBuildInputs = [ cmake doxygen ];
  cmakeFlags = [ "-DOGDF_WARNING_ERRORS=OFF"
                 "-DCMAKE_CXX_FLAGS=-fPIC"
               ];

  meta = {
    description = "Open Graph Drawing Framework/Open Graph algorithms and Data structure Framework";
    homepage = http://www.ogdf.net;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ianwookim ];
    platforms = stdenv.lib.platforms.all;
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
