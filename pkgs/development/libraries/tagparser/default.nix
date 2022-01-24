{ stdenv
, pkgs
, fetchFromGitHub
, cmake
, cpp-utilities
, zlib
}:

stdenv.mkDerivation rec {
  pname = "tagparser";
  version = "9.4.0";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "tagparser";
    rev = "v${version}";
    sha256 = "097dq9di19d3mvnlrav3fm78gzjni5babswyv10xnrxfhnf14f6x";
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

