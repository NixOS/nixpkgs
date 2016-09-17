{ stdenv, fetchFromGitHub, cmake, boost, curl, leatherman }:

stdenv.mkDerivation rec {
  name = "cpp-hocon-${version}";
  version = "0.1.2";

  src = fetchFromGitHub {
    sha256 = "0v2mnak6fh13dkl25lfvw1la2dfjqrh3lq1d40r3a52m56vwflrg";
    rev = version;
    repo = "cpp-hocon";
    owner = "puppetlabs";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost curl leatherman ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = " A C++ port of the Typesafe Config library";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
