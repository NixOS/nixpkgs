{ stdenv, fetchFromGitHub, cmake, pkgconfig, libX11, libpthreadstubs, libXau, libXdmcp
, libXext, libvdpau, glib, libva, ffmpeg_3, libGLU }:

stdenv.mkDerivation rec {
  pname = "libvdpau-va-gl";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = "libvdpau-va-gl";
    rev = "v${version}";
    sha256 = "0asndybfv8xb0fx73sjjw5kydqrahqkm6n04lh589pbf18s5qlld";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libX11 libpthreadstubs libXau libXdmcp libXext libvdpau glib libva ffmpeg_3 libGLU ];

  doCheck = false; # fails. needs DRI access

  meta = with stdenv.lib; {
    homepage = "https://github.com/i-rinat/libvdpau-va-gl";
    description = "VDPAU driver with OpenGL/VAAPI backend";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
