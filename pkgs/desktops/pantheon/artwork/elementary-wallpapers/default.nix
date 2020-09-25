{ stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, gettext
}:

stdenv.mkDerivation rec {
  pname = "elementary-wallpapers";
  version = "5.5.0";

  repoName = "wallpapers";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-Q5sYDXqFhiTu8nABmyND3L8bIXd1BJ3GZQ9TL3SzwzA=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Collection of wallpapers for elementary";
    homepage = "https://github.com/elementary/wallpapers";
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}

