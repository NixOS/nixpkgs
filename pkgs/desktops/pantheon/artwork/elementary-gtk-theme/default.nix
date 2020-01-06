{ stdenv
, fetchFromGitHub
, pantheon
, meson
, ninja
, gettext
}:

stdenv.mkDerivation rec {
  pname = "elementary-gtk-theme";
  version = "5.4.0";

  repoName = "stylesheet";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "0dh7lqc9b4ciyzbphqw071xcg742fvlc7gz9l1q3nqjsa2k6xg80";
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
