{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "elementary-sound-theme";
  version = "1.1.0";

  repoName = "sound-theme";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-fR6gtKx9J6o2R1vQZ5yx4kEX3Ak+q8I6hRVMZzyB2E8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "A set of system sounds for elementary";
    homepage = "https://github.com/elementary/sound-theme";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
