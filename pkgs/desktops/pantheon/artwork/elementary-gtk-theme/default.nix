{ stdenv
, fetchFromGitHub
, pantheon
, meson
, ninja
, gettext
}:

stdenv.mkDerivation rec {
  pname = "elementary-gtk-theme";
  version = "5.4.1";

  repoName = "stylesheet";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "0fnh08wqlhvigkxp69xkdha19ny9j0hg4ycwhhwvyr0d0z47kilw";
  };

  passthru = {
    updateScript = pantheon.updateScript {
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
    homepage = https://github.com/elementary/stylesheet;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
