{ lib
, pkgs
, mkDerivation
, libcanberra
, pulseaudio
, fetchFromGitHub
, cmake
, extra-cmake-modules
, kio
, kidletime
}:

mkDerivation rec {
  pname = "maui-core";
<<<<<<< HEAD
  version = "0.6.6";
=======
  version = "0.5.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Nitrux";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    sha256 = "sha256-o0Xwh9w0cClMw85FwpQB9CNWoSnzARxs6aGfvCA4BhA=";
=======
    sha256 = "sha256-58ja76N7LrJ0f/SsNMYr7Z9hdW60PwsNlTkHQ+NEdUM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kidletime
    kio
    libcanberra
    pulseaudio
  ];

  meta = with lib; {
    description = "Core libraries to manage the desktop to be shared between Maui Settings and Cask";
    homepage = "https://github.com/Nitrux/maui-core";
    # Missing license information https://github.com/Nitrux/maui-core/issues/1
    license = licenses.unfree;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };

}
