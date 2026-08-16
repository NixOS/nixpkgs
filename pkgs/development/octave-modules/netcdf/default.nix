{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  netcdf,
  nix-update-script,
  pkg-config,
  autoreconfHook,
}:

buildOctavePackage rec {
  pname = "netcdf";
  version = "1.0.20";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-netcdf";
    tag = "v${version}";
    sha256 = "sha256-47+8daOrPjjsVWi6Sz2V/GNK4vQ5nbGCrQmgnZRap+k=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  propagatedBuildInputs = [
    netcdf
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

  meta = {
    homepage = "https://gnu-octave.github.io/packages/netcdf/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "NetCDF interface for Octave";
  };
}
