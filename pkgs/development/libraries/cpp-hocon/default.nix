{ stdenv, fetchFromGitHub, cmake, boost, curl, leatherman }:

stdenv.mkDerivation rec {
  pname = "cpp-hocon";
  version = "0.2.2";

  src = fetchFromGitHub {
    sha256 = "1c8zy4hi0182k0vfx5l8bjq1iv7lvvw1zi4vy3429s898rx7z3d3";
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
