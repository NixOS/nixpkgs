{ stdenv, fetchurl, cmake, boost, openssl }:

stdenv.mkDerivation rec {
  name = "cpp-netlib-${version}";
  version = "0.12.0";

  src = fetchurl {
    url = "http://downloads.cpp-netlib.org/${version}/${name}-final.tar.bz2";
    sha256 = "0h7gyrbr3madycnj8rl8k1jzk2hd8np2k5ad9mijlh0fizzzk3h8";
  };

  buildInputs = [ cmake boost openssl ];

  cmakeFlags = [
    "-DCPP-NETLIB_BUILD_SHARED_LIBS=ON"
    "-DCMAKE_BUILD_TYPE=RELEASE"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description =
      "Collection of open-source libraries for high level network programming";
    homepage    = http://cpp-netlib.org;
    license     = licenses.boost;
    platforms   = platforms.all;
    maintainers = with maintainers; [ nckx ];
  };
}
