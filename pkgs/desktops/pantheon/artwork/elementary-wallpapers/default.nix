{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, gettext
, meson
, ninja
, python3
}:

stdenv.mkDerivation rec {
  pname = "elementary-wallpapers";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wallpapers";
    rev = version;
    sha256 = "sha256-qbqYr+3Vqwi1UBD0fRW6lI2rj5Iy51taZRGxDTpKfpg=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    python3
  ];

  postPatch = ''
    chmod +x meson/symlink.py
    patchShebangs meson/symlink.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Collection of wallpapers for elementary";
    homepage = "https://github.com/elementary/wallpapers";
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}

