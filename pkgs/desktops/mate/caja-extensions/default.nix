{ stdenv, fetchurl, pkgconfig, intltool, gtk3, dbus-glib, gupnp, mate, imagemagick, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "caja-extensions-${version}";
  version = "1.20.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "01k7c3gw6rfd7vlch61zig22bvz40wlnalc5p3rz4d9i98fr643n";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    dbus-glib
    gupnp
    mate.caja
    mate.mate-desktop
    imagemagick
  ];

  postPatch = ''
    for f in image-converter/caja-image-{resizer,rotator}.c; do
      substituteInPlace $f --replace "/usr/bin/convert" "${imagemagick}/bin/convert"
    done
  '';
  
  configureFlags = [ "--with-cajadir=$$out/lib/caja/extensions-2.0" ];

  meta = with stdenv.lib; {
    description = "Set of extensions for Caja file manager";
    homepage = http://mate-desktop.org;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
