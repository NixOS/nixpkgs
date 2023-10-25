{ lib, stdenv, fetchurl, intltool }:

stdenv.mkDerivation rec {
  pname = "pxlib";
  version = "0.6.8";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1yafwz4z5h30hqvk51wpgbjlmq9f2z2znvfim87ydrfrqfjmi6sz";
  };

  nativeBuildInputs = [ intltool ];

  meta = with lib; {
    description = "Library to read and write Paradox files";
    homepage = "https://pxlib.sourceforge.net/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.winpat ];
  };
}
