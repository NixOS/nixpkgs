{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  vapoursynth,
}:

stdenv.mkDerivation {
  pname = "vapoursynth-hqdn3d";
  version = "unstable-2023-07-09";

  src = fetchFromGitHub {
    owner = "Hinterwaeldlers";
    repo = "vapoursynth-hqdn3d";
    rev = "eb820cb23f7dc47eb67ea95def8a09ab69251d30";
    hash = "sha256-BObHZs7GQW6UFUwohII1MXHtk5ooGh/LfZ3ZsqoPQBU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ vapoursynth ];

  configureFlags = [ "--libdir=$(out)/lib/vapoursynth" ];

  postInstall = ''
    rm -f $out/lib/vapoursynth/*.la
  '';

  meta = {
    inherit (vapoursynth.meta) platforms;
    description = "Plugin for VapourSynth: hqdn3d";
    homepage = "https://github.com/Hinterwaeldlers/vapoursynth-hqdn3d";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ snaki ];
  };
}
