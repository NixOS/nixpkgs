{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, gettext
, meson
, ninja
, python3
}:

stdenv.mkDerivation rec {
  pname = "elementary-wallpapers";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wallpapers";
    rev = version;
    sha256 = "sha256-E/cUxa/GNt/01EjuuvurHxJu3qV9e+jcdcCi2+NxVDA=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    python3
  ];

  postPatch = ''
    chmod +x meson/symlink.py
    patchShebangs meson/symlink.py
  '';

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
    maintainers = teams.pantheon.members;
  };
}

