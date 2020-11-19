{ stdenv, fetchFromGitHub, installShellFiles, cmake }:

stdenv.mkDerivation rec {
  pname = "doctest";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "onqtam";
    repo = "doctest";
    rev = version;
    sha256 = "17g7n6rjs90i0b231x5s934qnr8m80ga2yg1z344bnsdiqcjd63w";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/onqtam/doctest";
    description = "The fastest feature-rich C++11/14/17/20 single-header testing framework";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ davidtwco ];
  };
}
