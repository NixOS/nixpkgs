{
  lib,
  stdenv,
  fetchurl,
<<<<<<< HEAD
  meson,
  ninja,
  pkg-config,
  libdvdcss,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdvdread";
  version = "7.0.1";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdread/${finalAttrs.version}/libdvdread-${finalAttrs.version}.tar.xz";
    hash = "sha256-Lj4EowXBXDljqgOuG5qDwdI5iAAD/PPd6YbTlDNV1Ac=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ libdvdcss ];

  mesonFlags = [
    (lib.mesonEnable "libdvdcss" true)
  ];
=======
  libdvdcss,
}:

stdenv.mkDerivation rec {
  pname = "libdvdread";
  version = "6.1.3";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdread/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-zjVFSZeiCMvlDpEjLw5z+xrDRxllgToTuHMKjxihU2k=";
  };

  buildInputs = [ libdvdcss ];

  NIX_LDFLAGS = "-ldvdcss";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postInstall = ''
    ln -s dvdread $out/include/libdvdread
  '';

  meta = {
    homepage = "http://dvdnav.mplayerhq.hu/";
    description = "Library for reading DVDs";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.wmertens ];
    platforms = lib.platforms.unix;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
