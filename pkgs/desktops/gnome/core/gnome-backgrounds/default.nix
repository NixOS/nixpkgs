{ lib, stdenv, fetchurl, meson, ninja, pkg-config, gnome, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-backgrounds";
  version = "42.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-backgrounds/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "jbnaBtzxXiduvbiarUPzk9AKahd8MYj+XQuLXnrhX6U=";
  };

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-backgrounds"; attrPath = "gnome.gnome-backgrounds"; };
  };

  patches = [
    # Makes the database point to stable paths in /run/current-system/sw/share, which don't decay whenever this package's hash changes.
    # This assumes a nixos + gnome system, where this package is installed in environment.systemPackages,
    # and /share outputs are included in environment.pathsToLink.
    ./stable-dir.patch
  ];

  nativeBuildInputs = [ meson ninja pkg-config gettext ];

  meta = with lib; {
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
