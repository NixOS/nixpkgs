{ lib, buildDunePackage, dune-configurator, pkg-config, fetchFromGitHub, callPackage
, AudioToolbox
, ffmpeg-base ? callPackage ./base.nix { }
, ffmpeg-avutil, ffmpeg
, stdenv
, VideoToolbox
}:

buildDunePackage {
  pname = "ffmpeg-avcodec";

  minimalOCamlVersion = "4.08";

  inherit (ffmpeg-base) version src duneVersion;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ]
    ++ lib.optionals stdenv.isDarwin [ AudioToolbox VideoToolbox ];
  propagatedBuildInputs = [ ffmpeg-avutil ffmpeg.dev ];

  doCheck = true;

  meta = ffmpeg-base.meta // {
    description = "Bindings for the ffmpeg avcodec library";
  };

}
