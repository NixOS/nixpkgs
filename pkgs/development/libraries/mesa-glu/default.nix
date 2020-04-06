{ stdenv, fetchurl, pkgconfig, libGL, ApplicationServices }:

stdenv.mkDerivation rec {
  pname = "glu";
  version = "9.0.1";

  src = fetchurl {
    url = "ftp://ftp.freedesktop.org/pub/mesa/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1g2m634p73mixkzv1qz1d0flwm390ydi41bwmchiqvdssqnlqnpv";
  };

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
