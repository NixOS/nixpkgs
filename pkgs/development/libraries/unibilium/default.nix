{ stdenv, lib, fetchFromGitHub, libtool, pkgconfig }:

stdenv.mkDerivation rec {
  name = "unibilium-${version}";

  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "mauke";
    repo = "unibilium";
    rev = "v${version}";
    sha256 = "143j7qrqjxxmdf3yzhn6av2qwiyjjk4cnskkgz6ir2scjfd5gvja";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ libtool pkgconfig ];

  meta = with lib; {
    description = "A very basic terminfo library";
    license = with licenses; [ lgpl3Plus ];
  };
}
