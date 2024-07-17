{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "matio";
  version = "1.5.27";
  src = fetchurl {
    url = "mirror://sourceforge/matio/${pname}-${version}.tar.gz";
    sha256 = "sha256-CmqgCxjEUStjqNJ5BrB5yMbtQdSyhE96SuWY4Y0i07M=";
  };

  meta = with lib; {
    description = "C library for reading and writing Matlab MAT files";
    homepage = "http://matio.sourceforge.net/";
    license = licenses.bsd2;
    maintainers = [ ];
    mainProgram = "matdump";
    platforms = platforms.all;
  };
}
