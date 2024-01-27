{ lib, stdenv, fetchurl, texinfo, lzip }:

stdenv.mkDerivation rec {
  pname = "lzlib";
  version = "1.13";
  outputs = [ "out" "info" ];

  nativeBuildInputs = [ texinfo lzip ];

  src = fetchurl {
    url = "mirror://savannah/lzip/${pname}/${pname}-${version}.tar.lz";
    sha256 = "sha256-3ea9WzJTXxeyjJrCS2ZgfgJQUGrBQypBEso8c/XWYsM=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.in --replace '-Wl,--soname=' '-Wl,-install_name,$(out)/lib/'
  '';

  makeFlags = [ "CC:=$(CC)" "AR:=$(AR)" ];
  doCheck = true;

  configureFlags = [ "--enable-shared" ];

  meta = with lib; {
    homepage = "https://www.nongnu.org/lzip/${pname}.html";
    description =
      "Data compression library providing in-memory LZMA compression and decompression functions, including integrity checking of the decompressed data";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ ehmry ];
  };
}
