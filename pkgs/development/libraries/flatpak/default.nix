{ stdenv, fetchurl, autoreconfHook, docbook_xml_dtd_412, docbook_xml_dtd_42, docbook_xml_dtd_43, docbook_xsl, which, libxml2
, gobject-introspection, gtk-doc, intltool, libxslt, pkgconfig, xmlto, appstream-glib, substituteAll, glibcLocales, yacc, xdg-dbus-proxy, p11-kit
, bubblewrap, bzip2, dbus, glib, gpgme, json-glib, libarchive, libcap, libseccomp, coreutils, gettext, python2, hicolor-icon-theme
, libsoup, lzma, ostree, polkit, python3, systemd, xorg, valgrind, glib-networking, wrapGAppsHook, gnome3 }:

stdenv.mkDerivation rec {
  pname = "flatpak";
  version = "1.2.4";

  # TODO: split out lib once we figure out what to do with triggerdir
  outputs = [ "out" "man" "doc" "installedTests" ];

  src = fetchurl {
    url = "https://github.com/flatpak/flatpak/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "1qf3ys84fzv11z6f6li59rxjdjbyrv7cyi9539k73r9i9pckjr8v";
  };

  patches = [
    (substituteAll {
      src = ./fix-test-paths.patch;
      inherit coreutils gettext glibcLocales;
      hicolorIconTheme = hicolor-icon-theme;
    })
    (substituteAll {
      src = ./fix-paths.patch;
      p11 = p11-kit;
    })
    (substituteAll {
      src = ./bubblewrap-paths.patch;
      inherit (builtins) storeDir;
    })
    # patch taken from gtk_doc
    ./respect-xml-catalog-files-var.patch
    ./use-flatpak-from-path.patch
    ./unset-env-vars.patch
  ];

  nativeBuildInputs = [
    autoreconfHook libxml2 docbook_xml_dtd_412 docbook_xml_dtd_42 docbook_xml_dtd_43 docbook_xsl which gobject-introspection
    gtk-doc intltool libxslt pkgconfig xmlto appstream-glib yacc wrapGAppsHook
  ];

  buildInputs = [
    bubblewrap bzip2 dbus gnome3.dconf glib gpgme json-glib libarchive libcap libseccomp
    libsoup lzma ostree polkit python3 systemd xorg.libXau
    gnome3.gsettings-desktop-schemas glib-networking
  ];

  checkInputs = [ valgrind ];

  doCheck = false; # TODO: some issues with temporary files

  NIX_LDFLAGS = [
    "-lpthread"
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-system-bubblewrap=${bubblewrap}/bin/bwrap"
    "--with-system-dbus-proxy=${xdg-dbus-proxy}/bin/xdg-dbus-proxy"
    "--localstatedir=/var"
    "--enable-installed-tests"
  ];

  makeFlags = [
    "installed_testdir=$(installedTests)/libexec/installed-tests/flatpak"
    "installed_test_metadir=$(installedTests)/share/installed-tests/flatpak"
  ];

  postPatch = ''
    patchShebangs buildutil
    patchShebangs tests
  '';

  meta = with stdenv.lib; {
    description = "Linux application sandboxing and distribution framework";
    homepage = https://flatpak.org/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
