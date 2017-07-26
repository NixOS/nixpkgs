{ stdenv, fetchFromGitHub, cmake, boost, curl, leatherman }:

stdenv.mkDerivation rec {
  name = "cpp-hocon-${version}";
  version = "0.1.5";

  src = fetchFromGitHub {
    sha256 = "0fc5468458mz572nbp45x5sblp6dsb4d1b6jqv77zf3mx5xyziz7";
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
