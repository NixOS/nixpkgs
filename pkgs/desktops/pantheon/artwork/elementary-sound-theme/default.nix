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
    sha256 = "sha256-v8ludbPCJaMHCxuzjZchTJwpGiF6UJlVMIMFg+lAhbU=";
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
