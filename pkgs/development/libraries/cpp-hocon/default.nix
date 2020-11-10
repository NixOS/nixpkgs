{ stdenv, fetchFromGitHub, cmake, boost, curl, leatherman }:

stdenv.mkDerivation rec {
  pname = "cpp-hocon";
  version = "0.3.0";

  src = fetchFromGitHub {
    sha256 = "0b24anpwkmvbsn5klnr58vxksw00ci9pjhwzx7a61kplyhsaiydw";
    rev = version;
    repo = "cpp-hocon";
    owner = "puppetlabs";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost curl leatherman ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "A C++ port of the Typesafe Config library";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.unix;
  };

}
