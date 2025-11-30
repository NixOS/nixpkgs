{
  buildDunePackage,
  dune-configurator,
  pkg-config,
  callPackage,
  ffmpeg-base ? callPackage ./base.nix { },
  ffmpeg-avutil,
  ffmpeg,
}:

buildDunePackage {
  pname = "ffmpeg-swscale";

  minimalOCamlVersion = "4.08";

  inherit (ffmpeg-base) version src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    ffmpeg-avutil
    ffmpeg.dev
  ];

  doCheck = true;

  meta = ffmpeg-base.meta // {
    description = "Bindings for the ffmpeg swscale library";
  };
}
