{
  lib,
  stdenv,
  fetchurl,
  libX11,
  libXext,
  libXt,
  imake,
  gccmakedep,
}:

stdenv.mkDerivation rec {
  pname = "xzoom";
  version = "0.3";
  patch = "24";

  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "http://www.ibiblio.org/pub/linux/libs/X/${pname}-${version}.tgz";
    sha256 = "0jzl5py4ny4n4i58lxx2hdwq9zphqf7h3m14spl3079y5mlzssxj";
  };
  patches = [
    (fetchurl {
      url = "http://http.debian.net/debian/pool/main/x/xzoom/xzoom_${version}-${patch}.diff.gz";
      sha256 = "0zhc06whbvaz987bzzzi2bz6h9jp6rv812qs7b71drivvd820qbh";
    })
  ];

  postPatch = ''
    sed -i 1i'#include <unistd.h>' xzoom.c
  '';

  nativeBuildInputs = [
    imake
    gccmakedep
  ];
  buildInputs = [
    libX11
    libXext
    libXt
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "BINDIR=$(out)/bin"
    "MANPATH=$(out)/share/man"
  ];
  installTargets = [
    "install"
    "install.man"
  ];

  meta = {
    description = "X11 screen zoom tool";
    license = lib.licenses.free;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    mainProgram = "xzoom";
  };
}
