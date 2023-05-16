{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, enableStatic ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "liboqs";
<<<<<<< HEAD
  version = "0.8.0";
=======
  version = "0.7.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "open-quantum-safe";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-h3mXoGRYgPg0wKQ1u6uFP7wlEUMQd5uIBt4Hr7vjNtA=";
=======
    sha256 = "sha256-cwrTHj/WFDZ9Ez2FhjpRhEx9aC5xBnh7HR/9T+zUpZc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if enableStatic then "OFF" else "ON"}"
    "-DOQS_DIST_BUILD=ON"
    "-DOQS_BUILD_ONLY_LIB=ON"
  ];

  dontFixCmake = true; # fix CMake file will give an error

  meta = with lib; {
    description = "C library for prototyping and experimenting with quantum-resistant cryptography";
    homepage = "https://openquantumsafe.org";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [];
  };
}
