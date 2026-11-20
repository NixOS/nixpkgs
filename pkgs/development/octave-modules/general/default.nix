{
  buildOctavePackage,
  lib,
  fetchurl,
  pkg-config,
  autoreconfHook,
  nettle,
}:

buildOctavePackage rec {
  pname = "general";
  version = "2.1.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-sTd31PWTLmiR8qrBPaF/IrjJuLT/jtAXllnr0ZEkFI8=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    nettle
  ];

  # autoreconfHook provides an autoreconfPhase that is run as a
  # preconfigurePhase, which means it runs AFTER the source is un-tarred, and
  # before buildOctavePackage's buildPhase re-tars it up into a format for later
  # consumption by Octave's "pkg build" command.
  preAutoreconf = ''
    pushd src
    rm -rf config.*
  '';
  postAutoreconf = ''
    popd
  '';

  meta = {
    homepage = "https://gnu-octave.github.io/packages/general/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "General tools for Octave";
  };
}
