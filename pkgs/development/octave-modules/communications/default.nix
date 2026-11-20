{
  buildOctavePackage,
  lib,
  fetchurl,
  autoreconfHook,
  pkg-config,
  signal,
  hdf5,
}:

buildOctavePackage rec {
  pname = "communications";
  version = "1.2.7";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-UXaoV45mdmA7n2cB8J3S+/8Nt7uhokyv2MVBm+FK5lw=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    hdf5
  ];

  requiredOctavePackages = [
    signal
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

  meta = {
    homepage = "https://gnu-octave.github.io/packages/communications/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "Digital Communications, Error Correcting Codes (Channel Code), Source Code functions, Modulation and Galois Fields";
  };
}
