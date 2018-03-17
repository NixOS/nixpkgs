{ stdenv, lib, fetchFromGitHub, autoreconfHook, python2, pkgconfig, libX11, libXext, glproto }:

let
  driverLink = "/run/opengl-driver" + lib.optionalString stdenv.isi686 "-32";
in stdenv.mkDerivation rec {
  name = "libglvnd-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "libglvnd";
    rev = "v${version}";
    sha256 = "1a126lzhd2f04zr3rvdl6814lfl0j077spi5dsf2alghgykn5iif";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig python2 ];
  buildInputs = [ libX11 libXext glproto ];

  NIX_CFLAGS_COMPILE = [
    "-UDEFAULT_EGL_VENDOR_CONFIG_DIRS"
    # FHS paths are added so that non-NixOS applications can find vendor files.
    "-DDEFAULT_EGL_VENDOR_CONFIG_DIRS=\"${driverLink}/share/glvnd/egl_vendor.d:/etc/glvnd/egl_vendor.d:/usr/share/glvnd/egl_vendor.d\""
  ];

  outputs = [ "out" "dev" ];

  passthru = { inherit driverLink; };

  meta = with stdenv.lib; {
    description = "The GL Vendor-Neutral Dispatch library";
    homepage = https://github.com/NVIDIA/libglvnd;
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
