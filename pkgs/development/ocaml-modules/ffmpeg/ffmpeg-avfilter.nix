{
  lib,
  buildDunePackage,
  dune-configurator,
  pkg-config,
  callPackage,
  AppKit,
  CoreImage,
  ffmpeg-base ? callPackage ./base.nix { },
  ffmpeg-avutil,
  ffmpeg,
  OpenGL,
  stdenv,
  VideoToolbox,
}:

buildDunePackage {
  pname = "ffmpeg-avfilter";

  minimalOCamlVersion = "4.08";

  inherit (ffmpeg-base) version src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ dune-configurator ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      AppKit
      CoreImage
      OpenGL
      VideoToolbox
    ];
  propagatedBuildInputs = [
    ffmpeg-avutil
    ffmpeg.dev
  ];

  doCheck = true;

  meta = ffmpeg-base.meta // {
    description = "Bindings for the ffmpeg avfilter library";
  };

}
