{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, expat, icu }:

stdenv.mkDerivation rec {
  pname = "liblcf";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "liblcf";
    rev = version;
    sha256 = "0b0bz9ydpc98mxbg78bgf8kil85kxyqgkzxgsjq7awzmyw7f3c1c";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  propagatedBuildInputs = [ expat icu ];

  meta = with lib; {
    description = "Library to handle RPG Maker 2000/2003 and EasyRPG projects";
    homepage = "https://github.com/EasyRPG/liblcf";
    license = licenses.mit;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.all;
  };
}
