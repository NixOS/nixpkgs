{ lib, stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  pname = "lzlib";
  version = "1.12";
  outputs = [ "out" "info" ];

  nativeBuildInputs = [ texinfo ];

  src = fetchurl {
    url = "mirror://savannah/lzip/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-jl2EJC61LPHcyY5YvZuo7xrvpQFDGr3QJzoiv0zjN7E=";
  };

  makeFlags = [ "AR:=$(AR)" "CC:=$(CC)" ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://www.nongnu.org/lzip/${pname}.html";
    description =
      "Data compression library providing in-memory LZMA compression and decompression functions, including integrity checking of the decompressed data";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ ehmry ];
  };
}
