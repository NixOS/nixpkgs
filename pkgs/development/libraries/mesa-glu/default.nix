{ stdenv, fetchurl, pkgconfig, libGL }:

stdenv.mkDerivation rec {
  name = "glu-${version}";
  version = "9.0.0";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/glu/${name}.tar.bz2";
    sha256 = "04nzlil3a6fifcmb95iix3yl8mbxdl66b99s62yzq8m7g79x0yhz";
  };
  postPatch = ''
    echo 'Cflags: -I''${includedir}' >> glu.pc.in
  '';

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ libGL ];

  outputs = [ "out" "dev" ];

  meta = {
    description = "OpenGL utility library";
    homepage = https://cgit.freedesktop.org/mesa/glu/;
    license = stdenv.lib.licenses.sgi-b-20;
    platforms = stdenv.lib.platforms.unix;
    broken = stdenv.hostPlatform.isAndroid;
  };
}
