# TODO: Resolve the issues with the Mono bindings.

{ stdenv, fetchurl, fetchpatch, lib
, pkgconfig, autoreconfHook
, glib, dbus-glib, gtkVersion ? "3"
, gtk2 ? null, libindicator-gtk2 ? null, libdbusmenu-gtk2 ? null
, gtk3 ? null, libindicator-gtk3 ? null, libdbusmenu-gtk3 ? null
, vala, gobject-introspection
, monoSupport ? false, mono ? null, gtk-sharp-2_0 ? null
 }:

with lib;


stdenv.mkDerivation rec {
  name = let postfix = if gtkVersion == "2" && monoSupport then "sharp" else "gtk${gtkVersion}";
          in "libappindicator-${postfix}-${version}";
  version = "${versionMajor}.${versionMinor}";
  versionMajor = "12.10";
  versionMinor = "0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "${meta.homepage}/${versionMajor}/${version}/+download/libappindicator-${version}.tar.gz";
    sha256 = "17xlqd60v0zllrxp8bgq3k5a1jkj0svkqn8rzllcyjh8k0gpr46m";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook vala gobject-introspection ];

  propagatedBuildInputs =
    if gtkVersion == "2"
    then [ gtk2 libdbusmenu-gtk2 ]
    else [ gtk3 libdbusmenu-gtk3 ];

  buildInputs = [
    glib dbus-glib
  ] ++ (if gtkVersion == "2"
    then [ libindicator-gtk2 ] ++ optionals monoSupport [ mono gtk-sharp-2_0 ]
    else [ libindicator-gtk3 ]);

  patches = [
    # Remove python2 from libappindicator.
    (fetchpatch {
      name = "no-python.patch";
      url = "https://src.fedoraproject.org/rpms/libappindicator/raw/8508f7a52437679fd95a79b4630373f08315f189/f/nopython.patch";
      sha256 = "18b1xzvwsbhhfpbzf5zragij4g79pa04y1dk6v5ci1wsjvii725s";
    })
  ];

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
    homepage = https://launchpad.net/libappindicator;
    license = with licenses; [ lgpl21 lgpl3 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}
