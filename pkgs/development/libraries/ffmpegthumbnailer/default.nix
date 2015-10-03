{ pkgs, fetchurl, stdenv, ffmpeg, cmake, libpng, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "ffmpegthumbnailer-${version}";
  version = "2.0.10";

  src = fetchurl {
    url = "https://github.com/dirkvdb/ffmpegthumbnailer/releases/download/${version}/${name}.tar.bz2";
    sha256 = "0q7ws7ysw2rwr6ja8rhdjcc7x1hrlga7n514wi4lhw1yma32q0m3";
  };

  buildInputs = [ ffmpeg cmake libpng pkgconfig ];

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
