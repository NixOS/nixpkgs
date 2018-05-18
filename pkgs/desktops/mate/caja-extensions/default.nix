{ stdenv, fetchurl, pkgconfig, intltool, gtk3, dbus-glib, gupnp, mate, imagemagick, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "caja-extensions-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1abi7s31mx7v8x0f747bmb3s8hrv8fv007pflv2n545yvn0m1dpj";
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
