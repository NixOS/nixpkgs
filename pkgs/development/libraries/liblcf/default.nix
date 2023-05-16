<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, expat, icu }:

stdenv.mkDerivation rec {
  pname = "liblcf";
  version = "0.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "liblcf";
    rev = version;
<<<<<<< HEAD
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
=======
    sha256 = "sha256-69cYZ8hJ92gK39gueaEoUM0K7BDWIQ/0NvcQ/6e3Sg8=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  propagatedBuildInputs = [ expat icu ];
  enableParallelBuilding = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Library to handle RPG Maker 2000/2003 and EasyRPG projects";
    homepage = "https://github.com/EasyRPG/liblcf";
    license = licenses.mit;
    maintainers = with maintainers; [ yana ];
    platforms = platforms.all;
  };
}
