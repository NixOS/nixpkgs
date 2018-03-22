# TODO: Resolve the issues with the Mono bindings.

{ stdenv, fetchurl, lib, file
, pkgconfig, autoconf
, glib, dbus-glib, gtkVersion
, gtk2 ? null, libindicator-gtk2 ? null, libdbusmenu-gtk2 ? null
, gtk3 ? null, libindicator-gtk3 ? null, libdbusmenu-gtk3 ? null
, python2Packages, gobjectIntrospection, vala
, monoSupport ? false, mono ? null, gtk-sharp-2_0 ? null
 }:

with lib;

let
  inherit (python2Packages) python pygobject2 pygtk;
in stdenv.mkDerivation rec {
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

  propagatedBuildInputs =
    if gtkVersion == "2"
    then [ gtk2 libdbusmenu-gtk2 ]
    else [ gtk3 libdbusmenu-gtk3 ];

  buildInputs = [
    glib dbus-glib
    python pygobject2 pygtk gobjectIntrospection vala
  ] ++ (if gtkVersion == "2"
    then [ libindicator-gtk2 ] ++ optionals monoSupport [ mono gtk-sharp-2_0 ]
    else [ libindicator-gtk3 ]);

  postPatch = ''
    substituteInPlace configure.ac \
      --replace '=codegendir pygtk-2.0' '=codegendir pygobject-2.0'
    autoconf
    for f in {configure,ltmain.sh,m4/libtool.m4}; do
      substituteInPlace $f \
        --replace /usr/bin/file ${file}/bin/file
    done
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
    homepage = https://launchpad.net/libappindicator;
    license = with licenses; [ lgpl21 lgpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
