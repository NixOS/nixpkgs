{ stdenv
, pkgs
, fetchFromGitHub
, cmake
, cpp-utilities
, zlib
}:

stdenv.mkDerivation rec {
  pname = "tagparser";
  version = "11.2.0";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "tagparser";
    rev = "v${version}";
    sha256 = "08and6gfmj4i96ls2g1b9llsb100mw3i37qzgpr76ywkkqnq0r2n";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    cpp-utilities zlib
  ];

  meta = with pkgs.lib; {
    homepage = "https://github.com/Martchus/tagparser";
    description = "C++ library for reading and writing MP4/M4A/AAC (iTunes), ID3, Vorbis, Opus, FLAC and Matroska tags";
    license = licenses.gpl2;
    maintainers = [ maintainers.matthiasbeyer ];
  };
}

