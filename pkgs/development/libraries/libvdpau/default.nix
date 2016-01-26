{ stdenv, fetchurl, pkgconfig, xorg }:

let
  driverLink = "/run/opengl-driver" + stdenv.lib.optionalString stdenv.isi686 "-32";
in stdenv.mkDerivation rec {
  name = "libvdpau-1.1.1";

  src = fetchurl {
    url = "http://people.freedesktop.org/~aplattner/vdpau/${name}.tar.bz2";
    sha256 = "857a01932609225b9a3a5bf222b85e39b55c08787d0ad427dbd9ec033d58d736";
  };

  buildInputs = with xorg; [ pkgconfig dri2proto libXext ];

  propagatedBuildInputs = [ xorg.libX11 ];

  configureFlags = [ "--with-module-dir=${driverLink}/lib/vdpau" ];

  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    cp -r $out/run/opengl-driver*/* $out
    cp -r $out/$out/* $out
    rm -rf $out/run $out/$(echo "$out" | cut -d "/" -f2)
  '';

  meta = with stdenv.lib; {
    homepage = http://people.freedesktop.org/~aplattner/vdpau/;
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = licenses.mit; # expat version
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
