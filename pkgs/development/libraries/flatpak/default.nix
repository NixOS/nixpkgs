{ stdenv, fetchurl, autoreconfHook, docbook_xml_dtd_412, docbook_xml_dtd_42, docbook_xml_dtd_43, docbook_xsl, which, libxml2
, gobjectIntrospection, gtk-doc, intltool, libxslt, pkgconfig, xmlto, appstream-glib, substituteAll, glibcLocales, yacc, xdg-dbus-proxy, p11-kit
, bubblewrap, bzip2, dbus, glib, gpgme, json-glib, libarchive, libcap, libseccomp, coreutils, python2, hicolor-icon-theme
, libsoup, lzma, ostree, polkit, python3, systemd, xorg, valgrind, glib-networking, makeWrapper, gnome3 }:

let
  version = "1.0.2";
  desktop_schemas = gnome3.gsettings-desktop-schemas;
in stdenv.mkDerivation rec {
  name = "flatpak-${version}";

  # TODO: split out lib once we figure out what to do with triggerdir
  outputs = [ "out" "man" "doc" "installedTests" ];

  src = fetchurl {
    url = "https://github.com/flatpak/flatpak/releases/download/${version}/${name}.tar.xz";
    sha256 = "0d0nnymb4p3njc24j0p6f74x7cdfi7jac714gxzzz5y5lrd651gn";
  };

  patches = [
    (substituteAll {
      src = ./fix-test-paths.patch;
      inherit coreutils glibcLocales;
      hicolorIconTheme = hicolor-icon-theme;
    })
    (substituteAll {
      src = ./fix-paths.patch;
      p11 = p11-kit;
    })
    # patch taken from gtk_doc
    ./respect-xml-catalog-files-var.patch
    ./use-flatpak-from-path.patch
  ];

  nativeBuildInputs = [
    autoreconfHook libxml2 docbook_xml_dtd_412 docbook_xml_dtd_42 docbook_xml_dtd_43 docbook_xsl which gobjectIntrospection
    gtk-doc intltool libxslt pkgconfig xmlto appstream-glib yacc makeWrapper
  ];

  buildInputs = [
    bubblewrap bzip2 dbus glib gpgme json-glib libarchive libcap libseccomp
    libsoup lzma ostree polkit python3 systemd xorg.libXau
  ];

  checkInputs = [ valgrind ];

  doCheck = false; # TODO: some issues with temporary files

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

  postFixup = ''
    wrapProgram $out/bin/flatpak \
      --prefix GIO_EXTRA_MODULES : "${glib-networking.out}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "${desktop_schemas}/share/gsettings-schemas/${desktop_schemas.name}"
  '';

  meta = with stdenv.lib; {
    description = "Linux application sandboxing and distribution framework";
    homepage = https://flatpak.org/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
