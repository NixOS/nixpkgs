{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, gettext
, sassc
}:

stdenv.mkDerivation rec {
  pname = "elementary-gtk-theme";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "stylesheet";
    rev = version;
    sha256 = "sha256-gciBn5MQ5Cu+dROL5kCt2GCbNA7W4HOWXyjMBd4OP+8=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    sassc
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "GTK theme designed to be smooth, attractive, fast, and usable";
    homepage = "https://github.com/elementary/stylesheet";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
