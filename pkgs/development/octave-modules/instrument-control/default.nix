{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  autoreconfHook,
}:

buildOctavePackage rec {
  pname = "instrument-control";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "instrument-control";
    tag = "release-${version}";
    sha256 = "sha256-oasZryYK/KgrIMZWU6j8g24MJMr5R6LwPvuqojAXbm4=";
  };

  nativeBuildInputs = [
    pkg-config
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release-(.*)"
    ];
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/instrument-control/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Low level I/O functions for serial, i2c, spi, parallel, tcp, gpib, vxi11, udp and usbtmc interfaces";
  };
}
