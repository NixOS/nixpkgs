{ lib, buildDunePackage, callPackage
, ffmpeg-base ? callPackage ./base.nix { }
, ffmpeg-avutil
, ffmpeg-avcodec
, ffmpeg-avfilter
, ffmpeg-swscale
, ffmpeg-swresample
, ffmpeg-av
, ffmpeg-avdevice
}:

buildDunePackage {
  pname = "ffmpeg";

  minimalOCamlVersion = "4.08";

  inherit (ffmpeg-base) version src;

  propagatedBuildInputs = [
    ffmpeg-avutil
    ffmpeg-avcodec
    ffmpeg-avfilter
    ffmpeg-swscale
    ffmpeg-swresample
    ffmpeg-av
    ffmpeg-avdevice
  ];

  # The tests fail
  doCheck = false;

  meta = ffmpeg-base.meta // {
    description = "Bindings for the ffmpeg libraries";
  };

}
