{
  lib,
  buildDunePackage,
  dune-configurator,
  pkg-config,
  callPackage,
  AudioToolbox,
  ffmpeg-base ? callPackage ./base.nix { },
  ffmpeg-avutil,
  ffmpeg-avcodec,
  ffmpeg,
  stdenv,
  VideoToolbox,
}:

buildDunePackage {
  pname = "ffmpeg-av";

  minimalOCamlVersion = "4.08";

  inherit (ffmpeg-base) version src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ dune-configurator ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      AudioToolbox
      VideoToolbox
    ];
  propagatedBuildInputs = [
    ffmpeg-avutil
    ffmpeg-avcodec
    ffmpeg.dev
  ];

  doCheck = true;

  meta = ffmpeg-base.meta // {
    description = "Bindings for the ffmpeg libraries -- top-level helpers";
  };

}
