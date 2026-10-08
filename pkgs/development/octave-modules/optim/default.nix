{
  buildOctavePackage,
  lib,
  fetchurl,
  struct,
  statistics,
  autoreconfHook,
  lapack,
  blas,
}:

buildOctavePackage rec {
  pname = "optim";
  version = "1.6.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-Wfs3caLSojE0R1MsWaLgAKanu3pnfz74GD+6qrVJOhQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    lapack
    blas
  ];

  requiredOctavePackages = [
    struct
    statistics
  ];

  # autoreconfHook provides an autoreconfPhase that is run as a
  # preconfigurePhase, which means it runs AFTER the source is un-tarred, and
  # before buildOctavePackage's buildPhase re-tars it up into a format for later
  # consumption by Octave's "pkg build" command.
  preAutoreconf = ''
    pushd src
    # Remove any files upstream generated for distribution.
    rm config.*
  '';
  postAutoreconf = ''
    popd
  '';

  meta = {
    homepage = "https://gnu-octave.github.io/packages/optim/";
    license = with lib.licenses; [
      gpl3Plus
      publicDomain
    ];
    # Modified BSD code seems removed
    maintainers = with lib.maintainers; [
      ravenjoad
      lnk3
    ];
    description = "Non-linear optimization toolkit";
  };
}
