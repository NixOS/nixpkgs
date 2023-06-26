{ lib, stdenv, fetchFromGitHub, installShellFiles, cmake }:

stdenv.mkDerivation rec {
  pname = "doctest";
  version = "2.4.11";

  src = fetchFromGitHub {
    owner = "doctest";
    repo = "doctest";
    rev = "v${version}";
    sha256 = "sha256-hotO6QVpPn8unYTaQHFgi40A3oLUd++I3aTe293e4Aw=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/doctest/doctest";
    description = "The fastest feature-rich C++11/14/17/20 single-header testing framework";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ davidtwco ];
  };
}
