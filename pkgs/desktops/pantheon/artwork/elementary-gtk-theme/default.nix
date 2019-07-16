{ stdenv, fetchFromGitHub, pantheon, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "stylesheet";
  version = "5.2.4";

  name = "elementary-gtk-theme-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1zhh9s4bmmk69k6j0klvfjmyv32wnwf0g575brm6gswn47nr2fni";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-gtk-theme";
    };
  };

  nativeBuildInputs = [
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
