{
  lib,
  stdenv,
  fetchurl,
  perl,
  libtool,
}:

stdenv.mkDerivation rec {
  pname = "libvterm-neovim";
  # Releases are not tagged, look at commit history to find latest release
  version = "0.3.3";

  src = fetchurl {
    url = "https://launchpad.net/libvterm/trunk/v${lib.versions.majorMinor version}/+download/libvterm-${version}.tar.gz";
    hash = "sha256-CRVvQ90hKL00fL7r5Q2aVx0yxk4M8Y0hEZeUav9yJuA=";
  };

  nativeBuildInputs = [
    perl
    libtool
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "LIBTOOL=${libtool}/bin/libtool"
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "VT220/xterm/ECMA-48 terminal emulator library";
    homepage = "http://www.leonerd.org.uk/code/libvterm/";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
    platforms = platforms.unix;
  };
}
