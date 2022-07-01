{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, expat, icu }:

stdenv.mkDerivation rec {
  pname = "liblcf";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "liblcf";
    rev = version;
    sha256 = "sha256-69cYZ8hJ92gK39gueaEoUM0K7BDWIQ/0NvcQ/6e3Sg8=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  propagatedBuildInputs = [ expat icu ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Library to handle RPG Maker 2000/2003 and EasyRPG projects";
    homepage = "https://github.com/EasyRPG/liblcf";
    license = licenses.mit;
    maintainers = with maintainers; [ yana ];
    platforms = platforms.all;
  };
}
