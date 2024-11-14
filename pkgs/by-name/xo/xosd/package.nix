{ lib, stdenv, fetchurl, libX11, libXext, libXt, xorgproto }:

stdenv.mkDerivation rec {
  pname = "xosd";
  version = "2.2.14";

  src = fetchurl {
    url = "mirror://sourceforge/libxosd/${pname}-${version}.tar.gz";
    sha256 = "025m7ha89q29swkc7s38knnbn8ysl24g2h5s7imfxflm91psj7sg";
  };

  buildInputs = [ libX11 libXext libXt xorgproto ];

  meta = with lib; {
    description = "Displays text on your screen";
    homepage = "https://sourceforge.net/projects/libxosd";
    license = licenses.gpl2Only;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
  };
}
