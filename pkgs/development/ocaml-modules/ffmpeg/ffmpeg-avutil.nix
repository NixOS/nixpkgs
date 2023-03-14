{ lib, stdenv, buildDunePackage, dune-configurator, pkg-config, fetchFromGitHub, callPackage
, AudioToolbox, VideoToolbox
, ffmpeg-base ? callPackage ./base.nix { }
, ffmpeg
}:

buildDunePackage {
  pname = "ffmpeg-avutil";

  minimalOCamlVersion = "4.08";

  inherit (ffmpeg-base) version src duneVersion;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ] ++ lib.optionals stdenv.isDarwin [ AudioToolbox VideoToolbox ];
  propagatedBuildInputs = [ ffmpeg.dev ];

  doCheck = true;

  meta = ffmpeg-base.meta // {
    description = "Bindings for the ffmpeg avutil libraries";
  };

}
