{ stdenv, fetchurl, autoreconfHook, docbook_xml_dtd_412, docbook_xml_dtd_42, docbook_xml_dtd_43, docbook_xsl, which, libxml2
, gobjectIntrospection, gtk_doc, intltool, libxslt, pkgconfig, xmlto, appstream-glib, substituteAll, glibcLocales, yacc
, bubblewrap, bzip2, dbus, glib, gpgme, json_glib, libarchive, libcap, libseccomp, coreutils, python2, hicolor-icon-theme
, libsoup, lzma, ostree, polkit, python3, systemd, xlibs, valgrind, glib_networking, makeWrapper, gnome3 }:

let
  version = "0.11.7";
  desktop_schemas = gnome3.gsettings_desktop_schemas;
in stdenv.mkDerivation rec {
  name = "flatpak-${version}";

  outputs = [ "out" "man" "doc" "installedTests" ];

  src = fetchurl {
    url = "https://github.com/flatpak/flatpak/releases/download/${version}/${name}.tar.xz";
    sha256 = "1vq4j7v68lp4fsvpas1bcsx1z4snpj0mkbq2mi00kx3jb48z768h";
  };

  patches = [
    (substituteAll {
      src = ./fix-test-paths.patch;
      inherit coreutils python2 glibcLocales;
      hicolorIconTheme = hicolor-icon-theme;
    })
    # patch taken from gtk_doc
    ./respect-xml-catalog-files-var.patch
  ];

  nativeBuildInputs = [
    autoreconfHook libxml2 docbook_xml_dtd_412 docbook_xml_dtd_42 docbook_xml_dtd_43 docbook_xsl which gobjectIntrospection
    gtk_doc intltool libxslt pkgconfig xmlto appstream-glib yacc makeWrapper
  ] ++ stdenv.lib.optionals doCheck checkInputs;

  buildInputs = [
    bubblewrap bzip2 dbus glib gpgme json_glib libarchive libcap libseccomp
    libsoup lzma ostree polkit python3 systemd xlibs.libXau
  ];

  checkInputs = [ valgrind ];

  doCheck = false; # TODO: some issues with temporary files

  enableParallelBuilding = true;

  configureFlags = [
    "--with-system-bubblewrap=${bubblewrap}/bin/bwrap"
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
      --prefix GIO_EXTRA_MODULES : "${glib_networking.out}/lib/gio/modules" \
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
