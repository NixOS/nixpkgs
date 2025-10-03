find_package(PkgConfig REQUIRED)

pkg_check_modules(FFMPEG REQUIRED IMPORTED_TARGET
  libavcodec
  libavformat
  libavutil
  libswscale
  libswresample
)

set(FFMPEG_LIBRARIES PkgConfig::FFMPEG)
