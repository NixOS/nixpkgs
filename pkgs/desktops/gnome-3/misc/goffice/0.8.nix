{ fetchurl, stdenv, pkgconfig, glib, gtk, libglade, bzip2
, pango, libgsf, libxml2, libart, intltool, gettext
, cairo, gconf, libgnomeui, pcre, gnome3/*just meta*/ }:

stdenv.mkDerivation rec {
  name = "goffice-0.8.17";

  src = fetchurl {
    url = "mirror://gnome/sources/goffice/0.8/${name}.tar.xz";
    sha256 = "165070beb67b84580afe80a8a100b674a81d553ab791acd72ac0c655f4fadb15";
  };

  # fix linking error: undefined reference to pcre_info
  patches = [ ./pcre_info.patch ]; # inspired by https://bugs.php.net/bug.php?id=60986

  buildInputs = [
    pkgconfig libglade bzip2 libart intltool gettext
    gconf libgnomeui pcre
  ];

  propagatedBuildInputs = [
    # All these are in the "Requires:" field of `libgoffice-0.6.pc'.
    glib libgsf libxml2 gtk libglade libart cairo pango
  ];

  postInstall =
    ''
      # Get GnuCash to build.  Might be unnecessary if we upgrade pkgconfig.
      substituteInPlace $out/lib/pkgconfig/libgoffice-*.pc --replace Requires.private Requires
    '';

  doCheck = true;

  meta = gnome3.goffice.meta // {
    maintainers = [ ];
  };
}
