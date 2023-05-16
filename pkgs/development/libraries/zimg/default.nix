{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "zimg";
<<<<<<< HEAD
  version = "3.0.5";
=======
  version = "3.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner  = "sekrit-twc";
    repo   = "zimg";
    rev    = "release-${version}";
<<<<<<< HEAD
    sha256 = "sha256-DCSqHCnOyIvKtIAfprb8tgtzLn67Ix6BWyeIliu0HO4=";
  };

  outputs = [ "out" "dev" "doc" ];

=======
    sha256 = "1069x49l7kh1mqcq1h3f0m5j0h832jp5x230bh4c613ymgg5kn00";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Scaling, colorspace conversion and dithering library";
    homepage    = "https://github.com/sekrit-twc/zimg";
    license     = licenses.wtfpl;
    platforms   = with platforms; unix ++ windows;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
