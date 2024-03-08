{ fetchFromGitHub, lib, stdenv, ffmpeg-headless, cmake, libpng, pkg-config, libjpeg
}:

stdenv.mkDerivation rec {
  pname = "ffmpegthumbnailer";
  version = "unstable-2022-02-18";

  src = fetchFromGitHub {
    owner = "dirkvdb";
    repo = "ffmpegthumbnailer";
    rev = "3db9fe895b2fa656bb40ddb7a62e27604a688171";
    sha256 = "0606pbg391l4s8mpyyalm9zrcnm75fwqdlrxy2gif9n21i2fm3rc";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ ffmpeg-headless libpng libjpeg ];
  cmakeFlags = [ "-DENABLE_THUMBNAILER=ON" ];

  # https://github.com/dirkvdb/ffmpegthumbnailer/issues/215
  postPatch = ''
    substituteInPlace libffmpegthumbnailer.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  meta = with lib;  {
    homepage = "https://github.com/dirkvdb/ffmpegthumbnailer";
    description = "A lightweight video thumbnailer";
    longDescription = "FFmpegthumbnailer is a lightweight video
        thumbnailer that can be used by file managers to create thumbnails
        for your video files. The thumbnailer uses ffmpeg o decode frames
        from the video files, so supported videoformats depend on the
        configuration flags of ffmpeg.
        This thumbnailer was designed to be as fast and lightweight as possible.
        The only dependencies are ffmpeg and libpng.
    ";
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.jagajaga ];
  };

}
