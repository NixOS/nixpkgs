{ stdenv, fetchFromGitHub, fetchpatch, cmake, shared ? false }:

stdenv.mkDerivation rec {
  pname = "pugixml";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "pugixml";
    rev = "v${version}";
    sha256 = "0iraznwm78pyyzc9snvd3dyz8gddvmxsm1b3kpw7wixkvcawdviv";
  };

  patches = [
    # To be removed after a version newer than 1.9 is released
    (fetchpatch {
      url = "https://github.com/zeux/pugixml/pull/193.patch";
      sha256 = "0s4anqlr2ppfibxyl29nrqbcprrg89k7il6303dm91s6620ydmka";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=${if shared then "ON" else "OFF"}" ];

  preConfigure = ''
    # Enable long long support (required for filezilla)
    sed -ire '/PUGIXML_HAS_LONG_LONG/ s/^\/\///' src/pugiconfig.hpp
  '';

  meta = with stdenv.lib; {
    description = "Light-weight, simple and fast XML parser for C++ with XPath support";
    homepage = https://pugixml.org;
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };
}
