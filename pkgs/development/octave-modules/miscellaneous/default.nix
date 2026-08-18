{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  nix-update-script,
  # Build-time dependencies
  ncurses, # >= 5
  units,
  pkg-config,
  autoreconfHook,
}:

buildOctavePackage rec {
  pname = "miscellaneous";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-miscellaneous";
    tag = "release-${version}";
    sha256 = "sha256-LuqRQefT2Z73113C18YSNvd9OBSr8GFBVVRZw/ucB7k=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    ncurses
  ];

  propagatedBuildInputs = [
    units
  ];

  # autoreconfHook provides an autoreconfPhase that is run as a
  # preconfigurePhase, which means it runs AFTER the source is un-tarred, and
  # before buildOctavePackage's buildPhase re-tars it up into a format for later
  # consumption by Octave's "pkg build" command.
  preAutoreconf = ''
    pushd src
  '';
  postAutoreconf = ''
    popd
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release-(.*)"
    ];
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/miscellaneous/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Miscellaneous tools that don't fit somewhere else";
  };
}
