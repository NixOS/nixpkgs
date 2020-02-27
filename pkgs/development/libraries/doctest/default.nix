{ stdenv, fetchFromGitHub, installShellFiles, cmake }:

stdenv.mkDerivation rec {
  pname = "doctest";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "onqtam";
    repo = "doctest";
    rev = version;
    sha256 = "0rddlzhnv0f5036q0m0p019pismka7sx6x8cnzk65sk77b1dsbhg";
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
