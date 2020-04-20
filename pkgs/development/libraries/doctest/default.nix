{ stdenv, fetchFromGitHub, installShellFiles, cmake }:

stdenv.mkDerivation rec {
  pname = "doctest";
  version = "2.3.7";

  src = fetchFromGitHub {
    owner = "onqtam";
    repo = "doctest";
    rev = version;
    sha256 = "134lx7pjnglrl4wdmyr9dz3rjb6d4ir6rvapg00gp52n44dbhnrq";
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
