{ stdenv, fetchurl, autoreconfHook, pkgconfig, udev }:

let version = "2.2.0"; in

stdenv.mkDerivation {
  name = "libcec-${version}";

  src = fetchurl {
    url = "https://github.com/Pulse-Eight/libcec/archive/libcec-${version}-repack.tar.gz";
    sha256 = "1kdfak8y96v14d5vp2apkjjs0fvvim9phc0nkhlq5pjlagk8v32x";
  };

  buildInputs = [ autoreconfHook pkgconfig udev ];

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
