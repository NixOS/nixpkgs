{ lib, stdenv, fetchFromGitHub, cmake, curl }:

stdenv.mkDerivation rec {
  pname = "concord";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "cogmasters";
    repo = "concord";
    rev = "v${version}";
    hash = "sha256-+nuVyqA/V/J6DWAeIs9Pv90ry3px1gJsF460qvfSEH8=";
  };

  buildInputs = [ curl ];

  makeFlags = [ "PREFIX=$(out)/local"];

  meta = with lib; {
    home = "https://cogmasters.github.io/concord/";
    description = "A Discord API wrapper library made in C ";
    license = licenses.mit;
    maintainers = with maintainers; [ mrtuxa ];
    platforms = platforms.linux;
  };