{ stdenv, fetchFromGitHub, cmake, pkgconfig, libX11, libpthreadstubs, libXau, libXdmcp
, libXext, libvdpau, glib, libva, ffmpeg, mesa_glu }:

stdenv.mkDerivation rec {
  name = "libvdpau-va-gl-${version}";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = "libvdpau-va-gl";
    rev = "v${version}";
    sha256 = "06lcg6zfj6mn17svz7s0y6ijdah55l9rnp9r440lcbixivjbgyn5";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libX11 libpthreadstubs libXau libXdmcp libXext libvdpau glib libva ffmpeg mesa_glu ];

  meta = with stdenv.lib; {
    homepage = https://github.com/i-rinat/libvdpau-va-gl;
    description = "VDPAU driver with OpenGL/VAAPI backend";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
