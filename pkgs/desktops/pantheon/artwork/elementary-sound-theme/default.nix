{ stdenv
, fetchFromGitHub
, pantheon
, meson
, ninja
, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "elementary-sound-theme";
  version = "1.0";

  repoName = "sound-theme";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1dc583lq61c361arjl3s44d2k72c46bqvcqv1c3s69f2ndsnxjdz";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "A set of system sounds for elementary";
    homepage = https://github.com/elementary/sound-theme;
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
