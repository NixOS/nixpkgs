{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "matio";
  version = "1.5.26";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${pname}-${version}.tar.gz";
    sha256 = "sha256-i0fCn1jkaNunpVVTccanKtTGqosV9FmysLZaMDwGOTM=";
  };

  meta = with lib; {
    description = "A C library for reading and writing Matlab MAT files";
    homepage = "http://matio.sourceforge.net/";
    license = licenses.bsd2;
    maintainers = [ ];
    mainProgram = "matdump";
    platforms = platforms.all;
  };
}
