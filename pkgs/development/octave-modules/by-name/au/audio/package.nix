{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  nix-update-script,
  jack2,
  alsa-lib,
  rtmidi,
  pkg-config,
  autoreconfHook,
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
    autoreconfHook
  ];

  propagatedBuildInputs = [
    jack2
    alsa-lib
    rtmidi
  ];

  # autoreconfHook provides an autoreconfPhase that is run as a
  # preconfigurePhase, which means it runs AFTER the source is un-tarred, and
  # before buildOctavePackage's buildPhase re-tars it up into a format for later
  # consumption by Octave's "pkg build" command.
  preAutoreconf = ''
    pushd src
    # Upstream's bootstrap script uses wget to fetch config.guess & config.sub
    # and has them committed to the repository. We must remove them so autoreconf
    # actually fires for our environment.
    rm config.*
  '';
  postAutoreconf = ''
    popd
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=release-(.*)" ]; };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/audio/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Audio and MIDI Toolbox for GNU Octave";
    platforms = lib.platforms.linux; # Because of run-time dependency on jack2 and alsa-lib
  };
}
