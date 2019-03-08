{ stdenv, fetchurl, pkgconfig, meson, ninja, gettext, gnome3, packagekit, polkit
, gtk3, systemd, wrapGAppsHook, desktop-file-utils }:

stdenv.mkDerivation rec {
  name = "gnome-packagekit-${version}";
  version = "3.32.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-packagekit/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "08rhsisdvx7pnx3rrg5v7c09jbw4grglkdj979gwl4a31j24zjsd";
  };

  nativeBuildInputs = [ pkgconfig meson ninja gettext wrapGAppsHook desktop-file-utils ];
  buildInputs = [ gtk3 packagekit systemd polkit ];

  postPatch = ''
    patchShebangs meson_post_install.sh
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-packagekit";
      attrPath = "gnome3.gnome-packagekit";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://www.freedesktop.org/software/PackageKit/;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    description = "Tools for installing software on the GNOME desktop using PackageKit";
  };
}
