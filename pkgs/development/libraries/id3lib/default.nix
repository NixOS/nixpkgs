{ lib, stdenv, fetchurl, libiconv, zlib }:

stdenv.mkDerivation rec {
  pname = "id3lib";
  version = "3.8.3";

  patches = [
    ./id3lib-3.8.3-gcc43-1.patch
    ./patch_id3lib_3.8.3_UTF16_writing_bug.diff
  ];

  buildInputs = [ libiconv zlib ];

  src = fetchurl {
    url = "mirror://sourceforge/id3lib/${pname}-${version}.tar.gz";
    sha256 = "0yfhqwk0w8q2hyv1jib1008jvzmwlpsxvc8qjllhna6p1hycqj97";
  };

  doCheck = false; # fails to compile

  meta = with lib; {
    description = "Library for reading, writing, and manipulating ID3v1 and ID3v2 tags";
    homepage = "http://id3lib.sourceforge.net";
    platforms = platforms.unix;
    license = licenses.lgpl2;
  };
}
