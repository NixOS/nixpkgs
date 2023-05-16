{ lib, stdenv, fetchFromGitHub
, pkg-config, cmake
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "ayatana-ido";
<<<<<<< HEAD
  version = "0.10.1";
=======
  version = "0.9.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-uecUyqSL02SRdlLbWIy0luHACTFoyMXQ6rOIYuisZsw=";
=======
    sha256 = "sha256-0LswdcV4VSg5o5uJ6vfw713eDnMbodZPQ9d2djxHc6k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config cmake ];

  buildInputs = [ gtk3 ];

  meta = with lib; {
    description = "Ayatana Display Indicator Objects";
    homepage = "https://github.com/AyatanaIndicators/ayatana-ido";
    changelog = "https://github.com/AyatanaIndicators/ayatana-ido/blob/${version}/ChangeLog";
    license = [ licenses.lgpl3Plus licenses.lgpl21Plus ];
    maintainers = [ maintainers.nickhu ];
    platforms = platforms.linux;
  };
}
