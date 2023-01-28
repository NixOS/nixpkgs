{ lib, buildDunePackage, dune-configurator, pkg-config, fetchFromGitHub, callPackage
, AppKit
, AudioToolbox
, Cocoa
, CoreImage
, ForceFeedback
, ffmpeg-base ? callPackage ./base.nix { }
, ffmpeg-av, ffmpeg
, OpenGL
, stdenv
, VideoToolbox
}:

buildDunePackage {
  pname = "ffmpeg-avdevice";

  minimalOCamlVersion = "4.08";

  inherit (ffmpeg-base) version src useDune2;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ]
    ++ lib.optionals stdenv.isDarwin [ AppKit AudioToolbox Cocoa CoreImage ForceFeedback OpenGL VideoToolbox ];
  propagatedBuildInputs = [ ffmpeg-av ffmpeg.dev ];

  doCheck = true;

  meta = ffmpeg-base.meta // {
    description = "Bindings for the ffmpeg avdevice library";
  };

}
