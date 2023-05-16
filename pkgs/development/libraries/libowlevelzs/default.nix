{ cmake
, fetchFromGitHub
, lib
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "libowlevelzs";
  version = "0.1.1";

  src = fetchFromGitHub {
<<<<<<< HEAD
    owner = "fogti";
=======
    owner = "zseri";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    repo = "libowlevelzs";
    rev = "v${version}";
    sha256 = "y/EaMMsmJEmnptfjwiat4FC2+iIKlndC2Wdpop3t7vY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Zscheile Lowlevel (utility) library";
<<<<<<< HEAD
    homepage = "https://github.com/fogti/libowlevelzs";
    license = licenses.mit;
    maintainers = [ maintainers.fogti ];
=======
    homepage = "https://github.com/zseri/libowlevelzs";
    license = licenses.mit;
    maintainers = with maintainers; [ zseri ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.all;
  };
}
