{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, udev
, libcec_platform
, withLibraspberrypi ? false
, libraspberrypi
}:

stdenv.mkDerivation rec {
  pname = "libcec";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "Pulse-Eight";
    repo = "libcec";
    rev = "libcec-${version}";
    sha256 = "sha256-OWqCn7Z0KG8sLlfMWd0btJIFJs79ET3Y1AV/y/Kj2TU=";
  };

  # Fix dlopen path
  postPatch = ''
    substituteInPlace include/cecloader.h --replace "libcec.so" "$out/lib/libcec.so"
  '';

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ udev libcec_platform ] ++
    lib.optional withLibraspberrypi libraspberrypi;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=1"
  ] ++ lib.optionals stdenv.isLinux [
    "-DHAVE_LINUX_API=1"
  ];

  meta = with lib; {
    description = "Allows you (with the right hardware) to control your device with your TV remote control using existing HDMI cabling";
    homepage = "http://libcec.pulse-eight.com";
    license = lib.licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.titanous ];
  };
}
