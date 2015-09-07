{ stdenv, fetchurl, cmake, pkgconfig, udev, libcec_platform }:

let version = "3.0.1"; in

stdenv.mkDerivation {
  name = "libcec-${version}";

  src = fetchurl {
    url = "https://github.com/Pulse-Eight/libcec/archive/libcec-${version}.tar.gz";
    sha256 = "0gi5gq8pz6vfdx80pimx23d5g243zzgmc7s8wpb686csjk470dky";
  };

  buildInputs = [ cmake pkgconfig udev libcec_platform ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=1" ];

  # Fix dlopen path
  patchPhase = ''
    substituteInPlace include/cecloader.h --replace "libcec.so" "$out/lib/libcec.so"
  '';

  meta = with stdenv.lib; {
    description = "Allows you (with the right hardware) to control your device with your TV remote control using existing HDMI cabling";
    homepage = "http://libcec.pulse-eight.com";
    repositories.git = "https://github.com/Pulse-Eight/libcec.git";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.titanous ];
  };
}
