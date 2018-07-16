{ stdenv, fetchFromGitHub, cmake, boost, curl, leatherman }:

stdenv.mkDerivation rec {
  name = "cpp-hocon-${version}";
  version = "0.1.7";

  src = fetchFromGitHub {
    sha256 = "0mfpz349c3arihvngw1a1gfhwlcw6wiwyc44bghjx1q109w7wm1m";
    rev = version;
    repo = "cpp-hocon";
    owner = "puppetlabs";
  };

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
