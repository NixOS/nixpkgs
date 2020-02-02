{ stdenv, fetchurl, cmake, pkgconfig, udev, libcec_platform, libraspberrypi ? null }:

let version = "4.0.4"; in

stdenv.mkDerivation {
  pname = "libcec";
  inherit version;

  src = fetchurl {
    url = "https://github.com/Pulse-Eight/libcec/archive/libcec-${version}.tar.gz";
    sha256 = "02j09y06csaic4m0fyb4dr9l3hl15nxbbniwq0i1qlccpxjak0j3";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake udev libcec_platform ] ++
    stdenv.lib.optional (libraspberrypi != null) libraspberrypi;

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=1" ];

  # Fix dlopen path
  patchPhase = ''
    substituteInPlace include/cecloader.h --replace "libcec.so" "$out/lib/libcec.so"
  '';

  meta = with stdenv.lib; {
    description = "Allows you (with the right hardware) to control your device with your TV remote control using existing HDMI cabling";
    homepage = http://libcec.pulse-eight.com;
    repositories.git = "https://github.com/Pulse-Eight/libcec.git";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.titanous ];
  };
}
