{ stdenv, lib, fetchFromGitHub, curl }:

stdenv.mkDerivation rec {
  pname = "concord";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "Cogmasters";
    repo = "concord";
    rev = "v${version}";
    hash = "sha256-+nuVyqA/V/J6DWAeIs9Pv90ry3px1gJsF460qvfSEH8=";
  };

  buildInputs = [ curl ];

  installFlags = [ "PREFIX=${"out"}" ];

  meta = with lib; {
    description = "A Discord API wrapper library made in C";
    homepage = "https://github.com/Cogmasters/concord";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ mrtuxa ];
  };
}