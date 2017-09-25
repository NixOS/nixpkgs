{ stdenv, fetchurl, lib, file
, pkgconfig, intltool
, glib, dbus_glib, json_glib
, gobjectIntrospection, vala_0_23, gnome_doc_utils
, gtkVersion ? null, gtk2 ? null, gtk3 ? null }:

with lib;

stdenv.mkDerivation rec {
  name = let postfix = if gtkVersion == null then "glib" else "gtk${gtkVersion}";
          in "libdbusmenu-${postfix}-${version}";
  version = "${versionMajor}.${versionMinor}";
  versionMajor = "12.10";
  versionMinor = "2";

  src = fetchurl {
    url = "${meta.homepage}/${versionMajor}/${version}/+download/libdbusmenu-${version}.tar.gz";
    sha256 = "9d6ad4a0b918b342ad2ee9230cce8a095eb601cb0cee6ddc1122d0481f9d04c9";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [
    glib dbus_glib json_glib
    gobjectIntrospection vala_0_23 gnome_doc_utils
  ] ++ optional (gtkVersion != null) (if gtkVersion == "2" then gtk2 else gtk3);

  postPatch = ''
    for f in {configure,ltmain.sh,m4/libtool.m4}; do
      substituteInPlace $f \
        --replace /usr/bin/file ${file}/bin/file
    done
  '';

  # https://projects.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/libdbusmenu
  preConfigure = ''
    export HAVE_VALGRIND_TRUE="#"
    export HAVE_VALGRIND_FALSE=""
  '';

  configureFlags = [
    "CFLAGS=-Wno-error"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (if gtkVersion == null then "--disable-gtk" else "--with-gtk=${gtkVersion}")
    "--disable-scrollkeeper"
  ] ++ optional (gtkVersion != "2") "--disable-dumper";

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = {
    description = "A library for passing menu structures across DBus";
    homepage = https://launchpad.net/dbusmenu;
    license = with licenses; [ gpl3 lgpl21 lgpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
