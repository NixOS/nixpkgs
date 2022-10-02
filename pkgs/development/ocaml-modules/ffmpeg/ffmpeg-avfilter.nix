{ lib, buildDunePackage, dune-configurator, pkg-config, fetchFromGitHub, callPackage
, ffmpeg-base ? callPackage ./base.nix { }
, ffmpeg-avutil, ffmpeg
}:

buildDunePackage {
  pname = "ffmpeg-avfilter";

  minimalOCamlVersion = "4.08";

  inherit (ffmpeg-base) version src useDune2;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ffmpeg-avutil ffmpeg.dev ];

  doCheck = true;

  meta = ffmpeg-base.meta // {
    description = "Bindings for the ffmpeg avfilter library";
  };

}
