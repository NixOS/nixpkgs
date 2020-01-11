{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, expat, icu }:

stdenv.mkDerivation rec {
  pname = "liblcf";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "liblcf";
    rev = version;
    sha256 = "18kx9h004bncyi0hbj6vrc7f4k8l1rwp96cwncv3xm0lwspj0vyl";
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
