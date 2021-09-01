{ lib, stdenv, fetchurl, cmake, pkg-config, udev, libcec_platform, libraspberrypi ? null }:

stdenv.mkDerivation rec {
  pname = "libcec";
  version = "6.0.2";

  src = fetchurl {
    url = "https://github.com/Pulse-Eight/libcec/archive/libcec-${version}.tar.gz";
    sha256 = "0xrkrcgfgr5r8r0854bw3i9jbq4jmf8nzc5vrrx2sxzvlkbrc1h9";
  };

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ udev libcec_platform ] ++
    lib.optional (libraspberrypi != null) libraspberrypi;

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=1" ];

  # Fix dlopen path
  patchPhase = ''
    substituteInPlace include/cecloader.h --replace "libcec.so" "$out/lib/libcec.so"
  '';

  meta = with lib; {
    description = "Allows you (with the right hardware) to control your device with your TV remote control using existing HDMI cabling";
    homepage = "http://libcec.pulse-eight.com";
    repositories.git = "https://github.com/Pulse-Eight/libcec.git";
    license = lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.titanous ];
  };
}
