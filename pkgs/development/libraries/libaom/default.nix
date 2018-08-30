{ stdenv, fetchgit, yasm, perl, cmake, pkgconfig, python3Packages }:

stdenv.mkDerivation rec {
  name = "libaom-${version}";
  version = "1.0.0";

  src = fetchgit {
    url = "https://aomedia.googlesource.com/aom";
    rev	= "v${version}";
    sha256 = "07h2vhdiq7c3fqaz44rl4vja3dgryi6n7kwbwbj1rh485ski4j82";
  };

  buildInputs = [ perl yasm ];
  nativeBuildInputs = [ cmake pkgconfig python3Packages.python ];

  meta = with stdenv.lib; {
    description = "AV1 Bitstream and Decoding Library";
    homepage    = https://aomedia.org/av1-features/get-started/;
    maintainers = with maintainers; [ kiloreux ];
    platforms   = platforms.all;
  };
}
