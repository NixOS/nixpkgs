{ stdenv, fetchurl, pkgconfig, xorg, libGL_driver
, fetchFromGitLab, autoreconfHook
}:

stdenv.mkDerivation rec {
  name = "libvdpau-${version}";
  version = "1.1.1.p1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "vdpau";
    repo = "libvdpau";
    # The only "more substatial" change atop 1.1.1 is
    # https://gitlab.freedesktop.org/vdpau/libvdpau/commit/53eeb07f
    rev = "52a6ea26";
    sha256 = "02bz5w789vyzrfs3hvl698faa8ayy8ads7j6l418dalhfwz3q550";
  };
  /*
  src = fetchurl {
    url = "https://people.freedesktop.org/~aplattner/vdpau/${name}.tar.bz2";
    sha256 = "857a01932609225b9a3a5bf222b85e39b55c08787d0ad427dbd9ec033d58d736"; # 1.1.1
  };
  */

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = with xorg; [ xorgproto libXext ];

  propagatedBuildInputs = [ xorg.libX11 ];

  configureFlags = stdenv.lib.optional stdenv.isLinux
    "--with-module-dir=${libGL_driver.driverLink}/lib/vdpau";

  installFlags = [ "moduledir=$(out)/lib/vdpau" ];

  meta = with stdenv.lib; {
    homepage = https://people.freedesktop.org/~aplattner/vdpau/;
    description = "Library to use the Video Decode and Presentation API for Unix (VDPAU)";
    license = licenses.mit; # expat version
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
