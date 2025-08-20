{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "elementary-sound-theme";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "sound-theme";
    rev = version;
    sha256 = "sha256-fR6gtKx9J6o2R1vQZ5yx4kEX3Ak+q8I6hRVMZzyB2E8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Set of system sounds for elementary";
    homepage = "https://github.com/elementary/sound-theme";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
