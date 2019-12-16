{ stdenv, fetchurl, pkgconfig, intltool, gtk3, gupnp, mate, imagemagick, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "caja-extensions";
  version = "1.22.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0xzhphzvaxbwyyp242pnhl5zjrkiznj90i0xjmy7pvi155pmp16h";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
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
    homepage = https://mate-desktop.org;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
