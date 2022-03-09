{ fetchFromGitHub, lib, stdenv, ffmpeg, cmake, libpng, pkg-config, libjpeg
}:

stdenv.mkDerivation rec {
  pname = "ffmpegthumbnailer";
  version = "unstable-2021-09-02";

  src = fetchFromGitHub {
    owner = "dirkvdb";
    repo = "ffmpegthumbnailer";
    rev = "d92e191dd793b12cee0a0f685f5a8d8252988399";
    sha256 = "1ysfq3g74b8ivivrdpfi4vm23d3cyc3rfla5i6y8q9aycis9xv6q";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ ffmpeg libpng libjpeg ];
  cmakeFlags = [ "-DENABLE_THUMBNAILER=ON" ];

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
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.jagajaga ];
  };

}
