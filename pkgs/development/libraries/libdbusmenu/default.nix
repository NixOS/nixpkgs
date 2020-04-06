{ stdenv, fetchurl, lib, file
, pkgconfig, intltool
, glib, dbus-glib, json-glib
, gobject-introspection, vala
, gtkVersion ? null, gtk2 ? null, gtk3 ? null }:

with lib;

stdenv.mkDerivation rec {
  name = let postfix = if gtkVersion == null then "glib" else "gtk${gtkVersion}";
          in "libdbusmenu-${postfix}-${version}";
  version = "${versionMajor}.${versionMinor}";
  versionMajor = "16.04";
  versionMinor = "0";

  src = fetchurl {
    url = "${meta.homepage}/${versionMajor}/${version}/+download/libdbusmenu-${version}.tar.gz";
    sha256 = "12l7z8dhl917iy9h02sxmpclnhkdjryn08r8i4sr8l3lrlm4mk5r";
  };

  nativeBuildInputs = [ vala pkgconfig intltool gobject-introspection ];

  buildInputs = [
    glib dbus-glib json-glib
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

  doCheck = false; # generates shebangs in check phase, too lazy to fix

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=\${TMPDIR}"
    "typelibdir=${placeholder "out"}/lib/girepository-1.0"
  ];

  meta = {
    description = "Library for passing menu structures across DBus";
    homepage = https://launchpad.net/dbusmenu;
    license = with licenses; [ gpl3 lgpl21 lgpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
