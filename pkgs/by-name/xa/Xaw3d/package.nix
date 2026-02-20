{
  lib,
  stdenv,
  fetchurl,
  bison,
  flex,
  pkg-config,
  libxext,
  libxmu,
  libxpm,
  libxp,
  libxt,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "Xaw3d";
  version = "1.6.6";

  src = fetchurl {
    url = "https://www.x.org/releases/individual/lib/libXaw3d-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-pBw+NxNa1hax8ou95wACr788tZow3zQUH4KdMurchkY=";
  };
  nativeBuildInputs = [
    pkg-config
    bison
    flex
  ];
  buildInputs = [
    libxext
    libxpm
    libxp
  ];
  propagatedBuildInputs = [
    libxmu
    libxt
    xorgproto
  ];

  meta = {
    description = "3D widget set based on the Athena Widget set";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
})
