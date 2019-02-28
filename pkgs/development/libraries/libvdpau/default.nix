{ stdenv, fetchurl, pkgconfig, xorg, libGL_driver }:

stdenv.mkDerivation rec {
  name = "libvdpau-${version}";
  version = "1.2";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/vdpau/libvdpau/uploads/14b620084c027d546fa0b3f083b800c6/${name}.tar.bz2";
    sha256 = "6a499b186f524e1c16b4f5b57a6a2de70dfceb25c4ee546515f26073cd33fa06";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = with xorg; [ xorgproto libXext ];

  propagatedBuildInputs = [ xorg.libX11 ];

  configureFlags = stdenv.lib.optional stdenv.isLinux
    "--with-module-dir=${libGL_driver.driverLink}/lib/vdpau";

  NIX_LDFLAGS = if stdenv.isDarwin then "-lX11" else null;

  installFlags = [ "moduledir=$(out)/lib/vdpau" ];

  meta = with stdenv.lib; {
    homepage = https://people.freedesktop.org/~aplattner/vdpau/;
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = licenses.mit; # expat version
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
