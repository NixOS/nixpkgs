{ stdenv, fetchFromGitHub, cmake, asciidoc }:

stdenv.mkDerivation rec {
  name = "zeromq-${version}";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "libzmq";
    rev = "v${version}";
    sha256 = "0z7ka82ihlsncqmf8jj4lnjyr418dzxfs0psx5mccqb09yx9shgm";
  };

  nativeBuildInputs = [ cmake asciidoc ];

  enableParallelBuilding = true;

  doCheck = false; # fails all the tests (ctest)

  meta = with stdenv.lib; {
    branch = "4";
    homepage = http://www.zeromq.org;
    description = "The Intelligent Transport Layer";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
