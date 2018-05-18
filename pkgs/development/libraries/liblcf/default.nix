{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, expat, icu }:

stdenv.mkDerivation rec {
  name = "liblcf-${version}";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "liblcf";
    rev = version;
    sha256 = "1y3pbl3jxan9f0cb1rxkibqjc0h23jm3jlwlv0xxn2pgw8l0fk34";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ expat icu ];

  meta = with stdenv.lib; {
    homepage = https://github.com/EasyRPG/liblcf;
    license = licenses.mit;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.linux;
  };
}
