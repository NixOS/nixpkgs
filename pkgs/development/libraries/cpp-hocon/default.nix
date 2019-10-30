{ stdenv, fetchFromGitHub, cmake, boost, curl, leatherman }:

stdenv.mkDerivation rec {
  pname = "cpp-hocon";
  version = "0.2.1";

  src = fetchFromGitHub {
    sha256 = "0ar7q3rp46m01wvfa289bxnk9xma3ydc67by7i4nrpz8vamvhwc3";
    rev = version;
    repo = "cpp-hocon";
    owner = "puppetlabs";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=catch-value";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost curl leatherman ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = " A C++ port of the Typesafe Config library";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
