{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorg,
  mesa,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "libvdpau";
  version = "1.5";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/vdpau/libvdpau/-/archive/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-pdUKQrjCiP68BxUatkOsjeBqGERpZcckH4m06BCCGRM=";
  };
  patches = [ ./installdir.patch ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = with xorg; [
    xorgproto
    libXext
  ];

  propagatedBuildInputs = [ xorg.libX11 ];

  mesonFlags = lib.optionals stdenv.isLinux [ "-Dmoduledir=${mesa.drivers.driverLink}/lib/vdpau" ];

  NIX_LDFLAGS = lib.optionalString stdenv.isDarwin "-lX11";

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/VDPAU/";
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = licenses.mit; # expat version
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
