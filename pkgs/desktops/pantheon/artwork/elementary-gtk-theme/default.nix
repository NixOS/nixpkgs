{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, gettext
, sassc
}:

stdenv.mkDerivation rec {
  pname = "elementary-gtk-theme";
  version = "6.1.0";

  repoName = "stylesheet";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-YvBjMbC3aQtYc/jPZmGdL4VfBH/VuxQ70PD0BWg9DTg=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    sassc
  ];

  meta = with lib; {
    description = "GTK theme designed to be smooth, attractive, fast, and usable";
    homepage = "https://github.com/elementary/stylesheet";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
