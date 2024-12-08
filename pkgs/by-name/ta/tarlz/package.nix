{ lib, stdenv, fetchurl, lzip, lzlib, texinfo }:

stdenv.mkDerivation rec {
  pname = "tarlz";
  version = "0.25";
  outputs = [ "out" "man" "info" ];

  nativeBuildInputs = [ lzip texinfo ];
  buildInputs = [ lzlib ];

  src = fetchurl {
    url = "mirror://savannah/lzip/tarlz/tarlz-${version}.tar.lz";
    hash = "sha256-fQu+nDoTe7k6EL5WmI/Pc2Lk28ZUkGOe3EJVtwQQX84=";
  };

  enableParallelBuilding = true;
  makeFlags = [ "CXX:=$(CXX)" ];

  doCheck = false; # system clock issues

  meta = with lib; {
    homepage = "https://www.nongnu.org/lzip/tarlz.html";
    description =
      "Massively parallel combined implementation of the tar archiver and the lzip compressor";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ehmry ];
    mainProgram = "tarlz";
  };
}
