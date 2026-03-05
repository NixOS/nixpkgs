{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  nix-update-script,
  jack2,
  alsa-lib,
  rtmidi,
  pkg-config,
}:

buildOctavePackage rec {
  pname = "audio";
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-audio";
    tag = "release-${version}";
    sha256 = "sha256-v7FKj9GSlX86zpOcw1xKxy150ivUxpjU/rvg+3OGs2s=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    jack2
    alsa-lib
    rtmidi
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=release-(.*)" ]; };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/audio/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Audio and MIDI Toolbox for GNU Octave";
    platforms = lib.platforms.linux; # Because of run-time dependency on jack2 and alsa-lib
    broken = true;
  };
}
