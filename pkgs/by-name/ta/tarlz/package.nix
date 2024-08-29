{ lib, stdenv, fetchurl, lzip, lzlib, texinfo }:

stdenv.mkDerivation rec {
  pname = "tarlz";
  version = "0.25";
  outputs = [ "out" "man" "info" ];

  nativeBuildInputs = [ lzip texinfo ];
  buildInputs = [ lzlib ];

  src = fetchurl {
    url = "mirror://savannah/lzip/tarlz/tarlz-${version}.tar.lz";
    sha256 = "7d0bbe9c3a137bb93a10be56988fcf7362e4dbc65490639edc4255b704105fce";
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
