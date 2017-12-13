{stdenv, fetchurl, zlib, cmake}:

stdenv.mkDerivation rec {
  name = "taglib-1.11.1";

  src = fetchurl {
    url = "http://taglib.org/releases/${name}.tar.gz";
    sha256 = "0ssjcdjv4qf9liph5ry1kngam1y7zp8fzr9xv4wzzrma22kabldn";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  meta = with stdenv.lib; {
    homepage = http://taglib.org/;
    repositories.git = git://github.com/taglib/taglib.git;
    shortDescription = "A library for reading and editing audio file metadata.";
    description = ''
      TagLib is a library for reading and editing the meta-data of several
      popular audio formats. Currently it supports both ID3v1 and ID3v2 for MP3
      files, Ogg Vorbis comments and ID3 tags and Vorbis comments in FLAC, MPC,
      Speex, WavPack, TrueAudio, WAV, AIFF, MP4 and ASF files.
    '';
    license = with licenses; [ lgpl3 mpl11 ];
    inherit (cmake.meta) platforms;
    maintainers = with maintainers; [ ttuegel ];
  };
}
