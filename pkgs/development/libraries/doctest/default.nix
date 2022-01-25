{ lib, stdenv, fetchFromGitHub, installShellFiles, cmake }:

stdenv.mkDerivation rec {
  pname = "doctest";
  version = "2.4.7";

  src = fetchFromGitHub {
    owner = "onqtam";
    repo = "doctest";
    rev = version;
    sha256 = "sha256-pXUg+NHSCKOudkmDCU3ePZrvs8DlM/CEZntEd78oTJ0=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/onqtam/doctest";
    description = "The fastest feature-rich C++11/14/17/20 single-header testing framework";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ davidtwco ];
  };
}
