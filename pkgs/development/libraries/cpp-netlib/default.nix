{ stdenv, fetchurl, cmake, boost, openssl }:

let
  version = "0.11.0";
in

stdenv.mkDerivation rec {
  name = "cpp-netlib-${version}";

  src = fetchurl {
    url = "http://commondatastorage.googleapis.com/cpp-netlib-downloads/${version}/${name}.tar.bz2";
    md5 = "0765cf203f451394df98e6ddf7bf2541";
  };

  buildInputs = [ cmake boost openssl ];

  cmakeFlags = [ "-DCPP-NETLIB_BUILD_SHARED_LIBS=ON" "-DCMAKE_BUILD_TYPE=RELEASE" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A collection of open-source libraries for high level network programming";
    homepage    = http://cpp-netlib.org;
    license     = licenses.boost;
    maintainers = with maintainers; [ shlevy ];
    platforms   = platforms.all;
  };
}
