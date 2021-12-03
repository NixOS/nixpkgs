{ lib, stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  pname = "lzlib";
  version = "1.10";
  outputs = [ "out" "info" ];

  nativeBuildInputs = [ texinfo ];

  src = fetchurl {
    url = "mirror://savannah/lzip/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-HWq3gApbQ+Vv0gYH/Sz9qeVQNQ3JX1vrakzhT4W0EEM=";
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
