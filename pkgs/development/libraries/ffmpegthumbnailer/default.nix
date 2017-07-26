{ pkgs, fetchFromGitHub, stdenv, ffmpeg, cmake, libpng, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "ffmpegthumbnailer-${version}";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "dirkvdb";
    repo = "ffmpegthumbnailer";
    rev = version;
    sha256 = "0kl8aa547icy9b05njps02a8sw4yn4f8fzs228kig247sn09s4cp";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ ffmpeg libpng ];

  meta = with stdenv.lib;  {
    homepage = https://github.com/dirkvdb/ffmpegthumbnailer;
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
    license = licenses.gpl2;
    maintainers = [ maintainers.jagajaga ];
  };

}
