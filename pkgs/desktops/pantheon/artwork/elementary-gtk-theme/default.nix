{ stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, gettext
}:

stdenv.mkDerivation rec {
  pname = "elementary-gtk-theme";
  version = "5.4.2";

  repoName = "stylesheet";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-eE0/LLdnpxOpBvdpioGKV/DOQ5lIuQt9dPnhGkQDGCs=";
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
  ];

  meta = with stdenv.lib; {
    description = "GTK theme designed to be smooth, attractive, fast, and usable";
    homepage = "https://github.com/elementary/stylesheet";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
