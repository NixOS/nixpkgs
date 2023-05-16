{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "sonivox";
<<<<<<< HEAD
  version = "3.6.12";
=======
  version = "3.6.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pedrolcl";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-df3EwscTF9n1fazz5Oa3FIXgWXHruhJBzMt8Y+ELP94=";
=======
    hash = "sha256-kCMY9A16g+CNNPn4PZ80QdEP6f58zCI3fQ1BFiK1ZQg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/pedrolcl/sonivox";
    description = "MIDI synthesizer library";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
