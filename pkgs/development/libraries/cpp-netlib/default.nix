{ stdenv, fetchFromGitHub, cmake, boost, openssl, asio }:

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

  # This can be removed when updating to 0.13, see https://github.com/cpp-netlib/cpp-netlib/issues/629
  propagatedBuildInputs = [ asio ];

  cmakeFlags = [
    "-DCPP-NETLIB_BUILD_SHARED_LIBS=ON"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description =
      "Collection of open-source libraries for high level network programming";
    homepage    = https://cpp-netlib.org;
    license     = licenses.boost;
    platforms   = platforms.all;
  };
}
