{ stdenv, fetchurl, intltool, mate }:

stdenv.mkDerivation rec {
  name = "mate-backgrounds-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0pcnjcw00y8hf2bwfrb5sbk2511cbg4fr8vgvgqswcwjp9y15cjp";
  };

  nativeBuildInputs = [ intltool ];

  meta = with stdenv.lib; {
    description = "Background images and data for MATE";
    homepage = https://mate-desktop.org;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
