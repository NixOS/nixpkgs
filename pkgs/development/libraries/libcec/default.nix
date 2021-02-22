{ lib, stdenv, fetchurl, cmake, pkg-config, udev, libcec_platform, libraspberrypi ? null }:

let version = "4.0.7"; in

stdenv.mkDerivation {
  pname = "libcec";
  inherit version;

  src = fetchurl {
    url = "https://github.com/Pulse-Eight/libcec/archive/libcec-${version}.tar.gz";
    sha256 = "0nii8qh3qrn92g8x3canj4glb2bjn6gc1p3f6hfp59ckd4vjrndw";
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
