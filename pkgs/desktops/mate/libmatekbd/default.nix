{ stdenv, fetchurl, fetchpatch, pkgconfig, intltool, gtk3, mate, libxklavier }:

stdenv.mkDerivation rec {
  name = "libmatekbd-${version}";
  version = "1.20.2";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1l1zbphs4snswf4bkrwkk6gsmb44bdhymcfgaaspzbrcmw3y7hr1";
  };

  patches = [
    # Fix build with glib 2.60 (TODO: remove after 1.22.0 update)
    (fetchpatch {
      url = https://github.com/mate-desktop/libmatekbd/commit/dc04e969dd61a2b1f82beae2d3c8ad105447812d.patch;
      sha256 = "1ps6mbj6hrm9djn4riya049w2cb0dknghysny8pafmvpkaqvckrb";
    })
  ];

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
