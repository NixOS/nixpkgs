{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  nix-update-script,
  autoreconfHook,
}:

buildOctavePackage rec {
  pname = "windows";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-windows";
    tag = "release-${version}";
    sha256 = "sha256-hr94VALlAEwpqNU7imEN63M0BdPFSu5IznhWOn/mNiQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
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
    homepage = "https://gnu-octave.github.io/packages/windows/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Provides COM interface and additional functionality on Windows";
    platforms = lib.platforms.windows;
  };
}
