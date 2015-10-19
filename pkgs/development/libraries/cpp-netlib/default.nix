{ stdenv, fetchurl, cmake, boost, libssl }:

let
  version = "0.11.2";
in

stdenv.mkDerivation rec {
  name = "cpp-netlib-${version}";

  src = fetchurl {
    url = "http://downloads.cpp-netlib.org/${version}/${name}-final.tar.bz2";
    sha256 = "0vwnp1jpvsdjaz7f7w55p7gw6hj7694nklmljcvphvkrhbw1g1q5";
  };

  buildInputs = [ cmake boost libssl ];

  cmakeFlags = [ "-DCPP-NETLIB_BUILD_SHARED_LIBS=ON" "-DCMAKE_BUILD_TYPE=RELEASE" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit version;
    description = "A collection of open-source libraries for high level network programming";
    homepage    = http://cpp-netlib.org;
    license     = licenses.boost;
    platforms   = platforms.all;
    maintainers = with maintainers; [ nckx ];
  };
}
