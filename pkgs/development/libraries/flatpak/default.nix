{ stdenv, fetchurl, autoreconfHook, docbook_xml_dtd_412, docbook_xml_dtd_42, docbook_xml_dtd_43, docbook_xsl, which, libxml2
, gobject-introspection, gtk-doc, intltool, libxslt, pkgconfig, xmlto, appstream-glib, substituteAll, glibcLocales, yacc, xdg-dbus-proxy, p11-kit
, bubblewrap, bzip2, dbus, glib, gpgme, json-glib, libarchive, libcap, libseccomp, coreutils, gettext, hicolor-icon-theme, fuse, nixosTests
, libsoup, lzma, ostree, polkit, python3, systemd, xorg, valgrind, glib-networking, wrapGAppsHook, dconf, gsettings-desktop-schemas, librsvg }:

stdenv.mkDerivation rec {
  pname = "flatpak";
  version = "1.4.2";

  # TODO: split out lib once we figure out what to do with triggerdir
  outputs = [ "out" "man" "doc" "installedTests" ];

  src = fetchurl {
    url = "https://github.com/flatpak/flatpak/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "08nmpp26mgv0vp3mlwk97rnp0j7i108h4hr9nllja19sjxnrlygj";
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
    ./validate-icon-pixbuf.patch
  ];

  nativeBuildInputs = [
    autoreconfHook libxml2 docbook_xml_dtd_412 docbook_xml_dtd_42 docbook_xml_dtd_43 docbook_xsl which gobject-introspection
    gtk-doc intltool libxslt pkgconfig xmlto appstream-glib yacc wrapGAppsHook
  ];

  buildInputs = [
    bubblewrap bzip2 dbus dconf glib gpgme json-glib libarchive libcap libseccomp
    libsoup lzma ostree polkit python3 systemd xorg.libXau fuse
    gsettings-desktop-schemas glib-networking
    librsvg # for flatpak-validate-icon
  ];

  checkInputs = [ valgrind ];

  doCheck = false; # TODO: some issues with temporary files

  NIX_LDFLAGS = "-lpthread";

  enableParallelBuilding = true;

  configureFlags = [
    "--with-system-bubblewrap=${bubblewrap}/bin/bwrap"
    "--with-system-dbus-proxy=${xdg-dbus-proxy}/bin/xdg-dbus-proxy"
    "--with-dbus-config-dir=${placeholder "out"}/share/dbus-1/system.d"
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

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.flatpak;
    };
  };

  meta = with stdenv.lib; {
    description = "Linux application sandboxing and distribution framework";
    homepage = https://flatpak.org/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
