{
  lib,
  stdenv,
  fetchurl,
  swi-prolog,
  tcsh,
  perl,
  patchelf,
  curl,
  directoryListingUpdater,
}:

stdenv.mkDerivation rec {
  pname = "TPTP";
  version = "10.0.0";

  src = fetchurl {
    urls = [
      "https://tptp.org/TPTP/Distribution/TPTP-v${version}.tgz"
      "https://storage.googleapis.com/tptp-web/TPTP/Archive/TPTP-v${version}.tgz"
    ];
    hash = "sha256-8jwsuExQHyyUQaTAVhEdTbmh4H3HRCF2BWP/DikXSZ4=";
  };

  nativeBuildInputs = [
    patchelf
    swi-prolog
  ];
  buildInputs = [
    tcsh
    swi-prolog
    perl
  ];

  installPhase = ''
    sharedir=$out/share/tptp

    mkdir -p $sharedir
    cp -r ./ $sharedir

    export TPTP=$sharedir

    patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath ${lib.getLib curl}/lib $sharedir/Scripts/tptp4X

    mkdir -p $out/bin
    ln -s $sharedir/Scripts/tptp2T $out/bin
    ln -s $sharedir/Scripts/tptp4X $out/bin
  '';

  passthru.updateScript = directoryListingUpdater {
    url = "https://tptp.tptp.org/";
    rev-prefix = "v";
  };

  meta = {
    description = "Thousands of problems for theorem provers and tools";
    maintainers = with lib.maintainers; [
      raskin
    ];
    # Gigabytes of data. Installation is unpacking and editing a few files.
    # No sense in letting Hydra build it.
    # Also, it is unclear what is covered by "verbatim" - we will edit configs
    hydraPlatforms = [ ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    homepage = "https://tptp.org/TPTP/";
  };
}
