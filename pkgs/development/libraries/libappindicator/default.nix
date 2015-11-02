# TODO: Resolve the issues with the Mono bindings.

{ stdenv, fetchurl, lib, file
, pkgconfig, autoconf
, glib, dbus_glib, gtkVersion
, gtk2 ? null, libindicator-gtk2 ? null, libdbusmenu-gtk2 ? null
, gtk3 ? null, libindicator-gtk3 ? null, libdbusmenu-gtk3 ? null
, python, pygobject, pygtk, gobjectIntrospection, vala
, monoSupport ? false, mono ? null, gtk-sharp ? null
 }:

with lib;

stdenv.mkDerivation rec {
  name = let postfix = if gtkVersion == "2" && monoSupport then "sharp" else "gtk${gtkVersion}";
          in "libappindicator-${postfix}-${version}";
  version = "${versionMajor}.${versionMinor}";
  versionMajor = "12.10";
  versionMinor = "0";

  src = fetchurl {
    url = "${meta.homepage}/${versionMajor}/${version}/+download/libappindicator-${version}.tar.gz";
    sha256 = "17xlqd60v0zllrxp8bgq3k5a1jkj0svkqn8rzllcyjh8k0gpr46m";
  };

  nativeBuildInputs = [ pkgconfig autoconf ];

  buildInputs = [
    glib dbus_glib
    python pygobject pygtk gobjectIntrospection vala
  ] ++ (if gtkVersion == "2"
    then [ gtk2 libindicator-gtk2 libdbusmenu-gtk2 ] ++ optionals monoSupport [ mono gtk-sharp ]
    else [ gtk3 libindicator-gtk3 libdbusmenu-gtk3 ]);

  postPatch = ''
    substituteInPlace configure.ac \
      --replace '=codegendir pygtk-2.0' '=codegendir pygobject-2.0'
    autoconf
    substituteInPlace {configure,ltmain.sh,m4/libtool.m4} \
      --replace /usr/bin/file ${file}/bin/file
  '';

  configureFlags = [
    "CFLAGS=-Wno-error"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-gtk=${gtkVersion}"
  ];

  postConfigure = ''
    substituteInPlace configure \
      --replace /usr/bin/file ${file}/bin/file
  '';

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = {
    description = "A library to allow applications to export a menu into the Unity Menu bar";
    homepage = "https://launchpad.net/libappindicator";
    license = with licenses; [ lgpl21 lgpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
