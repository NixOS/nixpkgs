{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, expat
, icu
}:

stdenv.mkDerivation rec {
  pname = "liblcf";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "liblcf";
    rev = version;
    hash = "sha256-jJGIsNw7wplTL5FBWGL8osb9255o9ZaWgl77R+RLDMM=";
  };

  dtrictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    expat
    icu
  ];

  enableParallelBuilding = true;
  enableParallelChecking = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = with lib; {
    description = "Library to handle RPG Maker 2000/2003 and EasyRPG projects";
    homepage = "https://github.com/EasyRPG/liblcf";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
