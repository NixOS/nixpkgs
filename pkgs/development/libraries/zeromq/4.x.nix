{ stdenv, fetchFromGitHub, cmake, asciidoc }:

stdenv.mkDerivation rec {
  name = "zeromq-${version}";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "libzmq";
    rev = "v${version}";
    sha256 = "12a2l6dzxkk1x8yl8bihnfs6gi2vgyi4jm9q8acj46f6niryhsmr";
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
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
