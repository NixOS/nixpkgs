{ stdenv, fetchgit, yasm, perl, cmake,  pkgconfig }:

stdenv.mkDerivation rec {
  name = "libaom-0.1.0";

  src = fetchgit {
    url = "https://aomedia.googlesource.com/aom";
    rev	= "105e9b195bb90c9b06edcbcb13b6232dab6db0b7";
    sha256 = "1fl2sca4df01gyn00s0xcwwirxccfnjppvjdrxdnb8f2naj721by";
  };

  buildInputs = [ perl yasm  ];
  nativeBuildInputs = [ cmake pkgconfig ];

  cmakeFlags = [
    "-DCONFIG_UNIT_TESTS=0"
  ];

  meta = with stdenv.lib; {
    description = "AV1 Bitstream and Decoding Library";
    homepage    = https://aomedia.org/av1-features/get-started/;
    maintainers = with maintainers; [ kiloreux ];
    platforms   = platforms.all;
  };
}