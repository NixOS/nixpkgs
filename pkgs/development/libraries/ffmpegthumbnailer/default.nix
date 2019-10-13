{ fetchFromGitHub, stdenv, ffmpeg, cmake, libpng, pkgconfig, libjpeg
}:

stdenv.mkDerivation rec {
  pname = "ffmpegthumbnailer";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "dirkvdb";
    repo = "ffmpegthumbnailer";
    rev = version;
    sha256 = "0mcdvyzny3yrdx23f3ww0i6lgkh68nzfcdla9d4vkc8l2b1kla1j";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ ffmpeg libpng libjpeg ];

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
