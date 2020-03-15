{ stdenv
, fetchFromGitHub
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
    sha256 = "0aqq0d21mqgrfiyhpfa8k51wxw2pia0qlsgp0sli79v7nwn3ykbq";
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
