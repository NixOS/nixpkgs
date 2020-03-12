{ stdenv, fetchFromGitHub, cmake, boost, openssl }:

stdenv.mkDerivation rec {
  pname = "cpp-netlib";
  version = "0.13.0-final";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "18782sz7aggsl66b4mmi1i0ijwa76iww337fi9sygnplz2hs03a3";
    fetchSubmodules = true;
  };

  buildInputs = [ cmake boost openssl ];

  cmakeFlags = [
    "-DCPP-NETLIB_BUILD_SHARED_LIBS=ON"
  ];

  enableParallelBuilding = true;

  # The test driver binary lacks an RPath to the library's libs
  preCheck = ''
    export LD_LIBRARY_PATH=$PWD/libs/network/src
  '';

  # Most tests make network GET requests to various websites
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Collection of open-source libraries for high level network programming";
    homepage    = https://cpp-netlib.org;
    license     = licenses.boost;
    platforms   = platforms.all;
  };
}
