{ stdenv, fetchurl, pkgconfig, libGL, ApplicationServices }:

stdenv.mkDerivation rec {
  pname = "glu";
  version = "9.0.0";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/glu/${pname}-${version}.tar.bz2";
    sha256 = "04nzlil3a6fifcmb95iix3yl8mbxdl66b99s62yzq8m7g79x0yhz";
  };
  postPatch = ''
    echo 'Cflags: -I''${includedir}' >> glu.pc.in
  '';

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ libGL ]
    ++ stdenv.lib.optional stdenv.isDarwin ApplicationServices;

  outputs = [ "out" "dev" ];

  meta = {
    description = "OpenGL utility library";
    homepage = https://cgit.freedesktop.org/mesa/glu/;
    license = stdenv.lib.licenses.sgi-b-20;
    platforms = stdenv.lib.platforms.unix;
    broken = stdenv.hostPlatform.isAndroid;
  };
}
