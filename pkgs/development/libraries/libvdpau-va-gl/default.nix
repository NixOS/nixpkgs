{ stdenv, fetchFromGitHub, cmake, pkgconfig, libX11, libpthreadstubs, libXau, libXdmcp
, libXext, libvdpau, glib, libva, ffmpeg, mesa_glu }:

stdenv.mkDerivation rec {
  name = "libvdpau-va-gl-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = "libvdpau-va-gl";
    rev = "v${version}";
    sha256 = "1y511jxs0df1fqzjcvb6zln7nbmchv1g6z3lw0z9nsf64ziycj8k";
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
