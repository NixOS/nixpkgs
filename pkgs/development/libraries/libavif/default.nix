{ stdenv, fetchFromGitHub, cmake, libaom }:

stdenv.mkDerivation rec {
  pname = "libavif";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "AOMediaCodec";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fs222cn1d60pv5fjsr92axk5dival70b6yqw0wng5ikk9zsdkhy";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libaom ];

  cmakeFlags = [ "-DAVIF_CODEC_AOM=ON" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/AOMediaCodec/libavif";
    description = "Library for encoding and decoding .avif files";
    platforms = platforms.all;
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
  };
}
