{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname   = "plplot";
  version = "5.15.0";

  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/${pname}/${pname}/${version}%20Source/${pname}-${version}.tar.gz";
    sha256 = "0ywccb6bs1389zjfmc9zwdvdsvlpm7vg957whh6b5a96yvcf8bdr";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCMAKE_SKIP_BUILD_RPATH=OFF" "-DBUILD_TEST=ON" ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Cross-platform scientific graphics plotting library";
    homepage    = "https://plplot.org";
    maintainers = with maintainers; [ bcdarwin ];
    platforms   = platforms.unix;
    license     = licenses.lgpl2;
  };
}
