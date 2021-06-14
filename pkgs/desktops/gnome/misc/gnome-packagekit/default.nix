{ lib, stdenv, fetchurl, pkg-config, meson, ninja, gettext, gnome, packagekit, polkit
, gtk3, systemd, wrapGAppsHook, desktop-file-utils }:

stdenv.mkDerivation rec {
  pname = "gnome-packagekit";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-packagekit/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "08rhsisdvx7pnx3rrg5v7c09jbw4grglkdj979gwl4a31j24zjsd";
  };

  nativeBuildInputs = [
    pkg-config meson ninja gettext wrapGAppsHook desktop-file-utils
  ];

  buildInputs = [ gtk3 packagekit systemd polkit ];

  postPatch = ''
    patchShebangs meson_post_install.sh
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-packagekit";
      attrPath = "gnome.gnome-packagekit";
    };
  };

  meta = with lib; {
    homepage = "https://www.freedesktop.org/software/PackageKit/";
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    description = "Tools for installing software on the GNOME desktop using PackageKit";
  };
}
