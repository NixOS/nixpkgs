{ stdenv, fetchFromGitHub, cmake, pkgconfig, libX11, libpthreadstubs, libvdpau, glib
, libva, ffmpeg, mesa_glu }:

let
  version = "0.3.4";

in stdenv.mkDerivation rec {
  name = "libvdpau-va-gl-${version}";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = "libvdpau-va-gl";
    rev = "v${version}";
    sha256 = "1909f3srm2iy2hv4m6jxg1nxrh9xgsnjs07wfzw3ais1fww0i2nn";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libX11 libpthreadstubs libvdpau glib libva ffmpeg mesa_glu ];

  meta = with stdenv.lib; {
    homepage = https://github.com/i-rinat/libvdpau-va-gl;
    description = "VDPAU driver with OpenGL/VAAPI backend";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
