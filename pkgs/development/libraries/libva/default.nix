{ stdenv, lib, fetchurl, libX11, pkgconfig, libXext, libdrm, libXfixes, wayland, libffi
, mesa_noglu ? null
}:

let
  withMesa = mesa_noglu != null;
in stdenv.mkDerivation rec {
  name = "libva-1.7.0";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/vaapi/releases/libva/${name}.tar.bz2";
    sha256 = "0py9igf4kicj7ji22bjawkpd6my013qpg0s4ir2np9l1rk5vr2d6";
  };

  buildInputs = [ libX11 libXext pkgconfig libdrm libXfixes wayland libffi mesa_noglu ];

  configureFlags = lib.optionals withMesa [
    "--with-drivers-path=${mesa_noglu.driverLink}/lib/dri"
    "--enable-glx"
  ];

  installFlags = [ "dummy_drv_video_ladir=$(out)/lib/dri" ];

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = licenses.mit;
    description = "VAAPI library: Video Acceleration API";
    platforms = platforms.unix;
  };
}
