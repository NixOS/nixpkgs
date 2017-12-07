{ stdenv, fetchurl, pkgconfig, udev, glib }:

stdenv.mkDerivation rec {
  name = "libgudev-${version}";
  version = "232";

  src = fetchurl {
    url = "mirror://gnome/sources/libgudev/${version}/${name}.tar.xz";
    sha256 = "ee4cb2b9c573cdf354f6ed744f01b111d4b5bed3503ffa956cefff50489c7860";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ udev glib ];

  # There's a dependency cycle with umockdev and the tests fail to LD_PRELOAD anyway.
  configureFlags = [ "--disable-umockdev" ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/libgudev;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
