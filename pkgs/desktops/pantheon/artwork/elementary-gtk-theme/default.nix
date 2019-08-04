{ stdenv, fetchFromGitHub, pantheon, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "stylesheet";
  version = "5.2.5";

  name = "elementary-gtk-theme-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0934rfdwkn4315mhayzba8a3b6i1xczp66gl6n45hh5c81gb2p65";
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
