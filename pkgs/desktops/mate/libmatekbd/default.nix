{ stdenv, fetchurl, pkgconfig, intltool, gtk3, mate, libxklavier }:

stdenv.mkDerivation rec {
  name = "libmatekbd-${version}";
  version = "1.20.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1d80xnbb8w51cv9cziybdxca037lksqkc5bd8wqlyb2p79z77426";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ gtk3 libxklavier ];

  meta = with stdenv.lib; {
    description = "Keyboard management library for MATE";
    homepage = https://github.com/mate-desktop/libmatekbd;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
