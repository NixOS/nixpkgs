{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "id3lib-3.8.3";

  patches = [
    ./id3lib-3.8.3-gcc43-1.patch
    ./patch_id3lib_3.8.3_UTF16_writing_bug.diff
  ];

  buildInputs = [ zlib ];
  
  src = fetchurl {
    url = mirror://sourceforge/id3lib/id3lib-3.8.3.tar.gz;
    sha256 = "0yfhqwk0w8q2hyv1jib1008jvzmwlpsxvc8qjllhna6p1hycqj97";
  };

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
