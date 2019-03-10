{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, expat, icu }:

stdenv.mkDerivation rec {
  name = "liblcf-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "liblcf";
    rev = version;
    sha256 = "1nhwwb32c3x0y82s0w93k0xz8h6xsd0sb4r1a0my8fd8p5rsnwbi";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  propagatedBuildInputs = [ expat icu ];

  meta = with stdenv.lib; {
    description = "Library to handle RPG Maker 2000/2003 and EasyRPG projects";
    homepage = https://github.com/EasyRPG/liblcf;
    license = licenses.mit;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.linux;
  };
}
