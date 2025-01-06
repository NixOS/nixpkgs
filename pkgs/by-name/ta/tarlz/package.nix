{ lib, stdenv, fetchurl, lzip, lzlib, texinfo }:

stdenv.mkDerivation rec {
  pname = "tarlz";
  version = "0.26";
  outputs = [ "out" "man" "info" ];

  nativeBuildInputs = [ lzip texinfo ];
  buildInputs = [ lzlib ];

  src = fetchurl {
    url = "mirror://savannah/lzip/tarlz/tarlz-${version}.tar.lz";
    hash = "sha256-U/4FXvcDSFcJddIgzq1WNvkXXwwHu+yORQuv8YuZmOQ=";
  };

  enableParallelBuilding = true;
  makeFlags = [ "CXX:=$(CXX)" ];

  doCheck = false; # system clock issues

  meta = {
    homepage = "https://www.nongnu.org/lzip/tarlz.html";
    description =
      "Massively parallel combined implementation of the tar archiver and the lzip compressor";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "tarlz";
  };
}
