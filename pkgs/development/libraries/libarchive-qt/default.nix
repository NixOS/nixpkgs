{ mkDerivation, lib, fetchFromGitLab, libarchive, xz, zlib, bzip2, meson, pkg-config, ninja }:

mkDerivation rec {
  pname = "libarchive-qt";
<<<<<<< HEAD
  version = "2.0.8";
=======
  version = "2.0.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "marcusbritanicus";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-31a6DsxObSJWyLfT6mVtyjloT26IwFHpH53iuyC2mco=";
=======
    sha256 = "sha256-KRywB+Op44N00q9tgO2WNCliRgUDRvrCms1O8JYt62o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libarchive
    bzip2
    zlib
    xz
  ];

  meta = with lib; {
    description = "A Qt based archiving solution with libarchive backend";
    homepage = "https://gitlab.com/marcusbritanicus/libarchive-qt";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
