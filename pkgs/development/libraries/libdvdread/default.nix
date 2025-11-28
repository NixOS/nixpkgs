{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  libdvdcss,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdvdread";
  version = "7.0.1";

  src = fetchurl {
    url = "http://get.videolan.org/libdvdread/${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-Lj4EowXBXDljqgOuG5qDwdI5iAAD/PPd6YbTlDNV1Ac=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ libdvdcss ];

  mesonFlags = [
    "-Dlibdvdcss=enabled"
  ];

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
})
