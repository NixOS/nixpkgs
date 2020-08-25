# TODO: Resolve the issues with the Mono bindings.

{ stdenv, fetchurl, fetchpatch, lib
, pkg-config, autoreconfHook, automake111x, gtk-doc
, glib, dbus-glib, gtkVersion ? "3"
, gtk2 ? null, libindicator-gtk2 ? null, libdbusmenu-gtk2 ? null, gnome2
, gtk3 ? null, libindicator-gtk3 ? null, libdbusmenu-gtk3 ? null, gnome3
, vala, gobject-introspection
, monoSupport ? false, mono ? null, gtk-sharp-2_0 ? null
 }:

with lib;

stdenv.mkDerivation rec {
  name = let postfix = if gtkVersion == "2" && monoSupport then "sharp" else "gtk${gtkVersion}";
          in "libappindicator-${postfix}-${version}";
  # pulled from tag, matched formatting with repology
  version = "12.10.1.201020200706.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    name = "libappindicator-${version}.tar.gz";
    url = "https://bazaar.launchpad.net/~indicator-applet-developers/libappindicator/trunk/tarball/298";
    sha256 = "0l9x2dcmsgp43j4rv5brx4vv2vpz34by8lbl3wp97sircniqkbl6";
  };

  sourceRoot = "~indicator-applet-developers/libappindicator/trunk";

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    vala
    gobject-introspection
    gtk-doc
  ] ++ (if gtkVersion == "2"
    then [ gnome2.gnome-common automake111x ]
    else [ gnome3.gnome-common ]);

  propagatedBuildInputs =
    if gtkVersion == "2"
    then [ gtk2 libdbusmenu-gtk2 ]
    else [ gtk3 libdbusmenu-gtk3 ];

  buildInputs = [
    glib dbus-glib
  ] ++ (if gtkVersion == "2"
    then [ libindicator-gtk2 ] ++ optionals monoSupport [ mono gtk-sharp-2_0 ]
    else [ libindicator-gtk3 ]);

  preAutoreconf = ''
    gnome-autogen.sh --enable-gtk-doc ''${configureFlags[@]}
  '';

  configureFlags = [
    "CFLAGS=-Wno-error"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-gtk=${gtkVersion}"
  ];

  doCheck = false; # generates shebangs in check phase, too lazy to fix

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
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
