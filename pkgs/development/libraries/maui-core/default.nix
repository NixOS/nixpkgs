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
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "Nitrux";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-58ja76N7LrJ0f/SsNMYr7Z9hdW60PwsNlTkHQ+NEdUM=";
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
  };

}
