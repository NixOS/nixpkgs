{ stdenv, fetchurl, pkgconfig, meson, ninja, gettext, gnome3, packagekit, polkit
, systemd, wrapGAppsHook, desktop-file-utils }:

stdenv.mkDerivation rec {
  name = "gnome-packagekit-${version}";
  version = "3.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-packagekit/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1i1hf6833psnq174xm0gjlz5rbrkl8i512y47w7nk8mrrrc31b35";
  };

  nativeBuildInputs = [ pkgconfig meson ninja gettext wrapGAppsHook desktop-file-utils ];
  buildInputs = [ gnome3.gtk packagekit systemd polkit ];

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
