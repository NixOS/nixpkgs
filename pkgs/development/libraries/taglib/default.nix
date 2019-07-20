{stdenv, fetchurl, zlib, cmake, fetchpatch}:

stdenv.mkDerivation rec {
  name = "taglib-1.11.1";

  src = fetchurl {
    url = "http://taglib.org/releases/${name}.tar.gz";
    sha256 = "0ssjcdjv4qf9liph5ry1kngam1y7zp8fzr9xv4wzzrma22kabldn";
  };

  patches = [
    (fetchpatch {
      # https://github.com/taglib/taglib/issues/829
      name = "CVE-2017-12678.patch";
      url = "https://github.com/taglib/taglib/commit/eb9ded1206f18.patch";
      sha256 = "1bvpxsvmlpi3by7myzss9kkpdkv405612n8ff68mw1ambj8h1m90";
    })

    (fetchpatch {
      # https://github.com/taglib/taglib/pull/869
      name = "CVE-2018-11439.patch";
      url = "https://github.com/taglib/taglib/commit/272648ccfcccae30e002ccf34a22e075dd477278.patch";
      sha256 = "0p397qq4anvcm0p8xs68mxa8hg6dl07chg260lc6k2929m34xv72";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  meta = with stdenv.lib; {
    homepage = http://taglib.org/;
    repositories.git = git://github.com/taglib/taglib.git;
    description = "A library for reading and editing audio file metadata.";
    longDescription = ''
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
