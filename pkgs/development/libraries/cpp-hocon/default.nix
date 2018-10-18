{ stdenv, fetchFromGitHub, cmake, boost, curl, leatherman }:

stdenv.mkDerivation rec {
  name = "cpp-hocon-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    sha256 = "084vsn080z8mp5s54jaq0qdwlx0p62nbw1i0rffkag477h8vq68i";
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
