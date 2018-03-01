{ stdenv, intltool, fetchurl, vala
, pkgconfig, gtk3, glib
, wrapGAppsHook, itstool, gnupg, libsoup
, gnome3, librsvg, gdk_pixbuf, gpgme
, libsecret, avahi, p11-kit, openssh }:

stdenv.mkDerivation rec {
  name = "seahorse-${version}";
  version = "3.20.0";

  src = fetchurl {
    url = "mirror://gnome/sources/seahorse/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "e2b07461ed54a8333e5628e9b8e517ec2b731068377bf376570aad998274c6df";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "seahorse"; attrPath = "gnome3.seahorse"; };
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 glib intltool itstool gnome3.gcr
                  gnome3.gsettings-desktop-schemas wrapGAppsHook gnupg
                  gdk_pixbuf gnome3.defaultIconTheme librsvg gpgme
                  libsecret avahi libsoup p11-kit vala
                  openssh ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gnome3.gnome-themes-standard}/share"
    )
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Seahorse;
    description = "Application for managing encryption keys and passwords in the GnomeKeyring";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
