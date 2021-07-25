{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, gettext
}:

stdenv.mkDerivation rec {
  pname = "elementary-wallpapers";
  version = "6.0.0";

  repoName = "wallpapers";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-KxXaBLKcsyKcJvWpxT3BE/PLfZE06/tJ0+Pq1A9H7uI=";
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

  meta = with lib; {
    description = "Collection of wallpapers for elementary";
    homepage = "https://github.com/elementary/wallpapers";
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}

