# TODO: Resolve the issues with the Mono bindings.

{ stdenv, fetchgit, lib
, pkg-config, autoreconfHook
, glib, dbus-glib, gtkVersion ? "3"
, gtk2 ? null, libindicator-gtk2 ? null, libdbusmenu-gtk2 ? null
, gtk3 ? null, libindicator-gtk3 ? null, libdbusmenu-gtk3 ? null
, gtk-doc, vala, gobject-introspection
, monoSupport ? false, mono ? null, gtk-sharp-2_0 ? null
 }:

with lib;


stdenv.mkDerivation rec {
  pname = let postfix = if gtkVersion == "2" && monoSupport then "sharp" else "gtk${gtkVersion}";
          in "libappindicator-${postfix}";
  version = "12.10.1+20.10.20200706.1";

  outputs = [ "out" "dev" ];

  src = fetchgit {
    url = "https://git.launchpad.net/ubuntu/+source/libappindicator";
    rev = "fe25e53bc7e39cd59ad6b3270cd7a6a9c78c4f44";
    sha256 = "0xjvbl4gn7ra2fs6gn2g9s787kzb5cg9hv79iqsz949rxh4iw32d";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook vala gobject-introspection gtk-doc ];

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
    gtkdocize
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
