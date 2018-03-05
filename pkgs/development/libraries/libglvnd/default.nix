{stdenv, fetchFromGitHub, autoreconfHook, python2, pkgconfig, libGL_driver, libX11, libXext, glproto }:

# Git version is needed for EGL and GLES handling.

stdenv.mkDerivation rec {
  name = "libglvnd-2016-12-22";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "libglvnd";
    rev = "dc16f8c337703ad141f83583a4004fcf42e07766";
    sha256 = "1dbwf1216np77xf1kx3ci3y7hfa1p4vgrrzg71gw36hqxf36vg5f";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig python2 ];
  buildInputs = [ libX11 libXext glproto ];

  NIX_CFLAGS_COMPILE = [
    "-UDEFAULT_EGL_VENDOR_CONFIG_DIRS"
    "-DDEFAULT_EGL_VENDOR_CONFIG_DIRS=\"${libGL_driver.driverLink}/share/glvnd/egl_vendor.d\""
  ];

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "The GL Vendor-Neutral Dispatch library";
    homepage = https://github.com/NVIDIA/libglvnd;
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
