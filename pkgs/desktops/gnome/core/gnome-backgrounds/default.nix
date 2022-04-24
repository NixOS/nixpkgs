{ stdenv
, lib
, fetchurl
, meson
, ninja
, gnome
}:

stdenv.mkDerivation rec {
  pname = "gnome-backgrounds";
  version = "42.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "TH/hoJ9FnF93GJpZglJPzgXYiJRJVdZ5kQ8jRgbBKV0=";
  };

  patches = [
    # Makes the database point to stable paths in /run/current-system/sw/share, which don't decay whenever this package's hash changes.
    # This assumes a nixos + gnome system, where this package is installed in environment.systemPackages,
    # and /share outputs are included in environment.pathsToLink.
    ./stable-dir.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-backgrounds";
      attrPath = "gnome.gnome-backgrounds";
    };
  };

  meta = with lib; {
    description = "Default wallpaper set for GNOME";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-backgrounds";
    license = licenses.cc-by-sa-30;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
