{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkg-config, jansson, openssl }:

stdenv.mkDerivation rec {
  pname = "libjwt";
<<<<<<< HEAD
  version = "1.16.0";
=======
  version = "1.15.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "benmcollins";
    repo = "libjwt";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-5hbmEen31lB6Xdv5WU+8InKa0+1OsuB8QG0jVa1+a2w=";
=======
    sha256 = "sha256-as4tqvRY559Q2R3s4GZHovqsCboXNz/NcV5lo+qCeOk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ jansson openssl ];
  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    homepage = "https://github.com/benmcollins/libjwt";
    description = "JWT C Library";
    license = licenses.mpl20;
    maintainers = with maintainers; [ pnotequalnp ];
    platforms = platforms.all;
  };
}
