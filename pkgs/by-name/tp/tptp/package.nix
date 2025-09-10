{
  lib,
  stdenv,
  fetchurl,
  swi-prolog,
  tcsh,
  perl,
  patchelf,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "TPTP";
  version = "9.1.0";

  src = fetchurl {
    urls = [
      "https://tptp.org/TPTP/Distribution/TPTP-v${version}.tgz"
      "https://tptp.org/TPTP/Archive/TPTP-v${version}.tgz"
    ];
    hash = "sha256-KylCpKEdjvXTzYU2MOi0FDrr4e6je2YB366+dxy3Xmo=";
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

    tcsh $sharedir/Scripts/tptp2T_install -default

    substituteInPlace $sharedir/TPTP2X/tptp2X_install --replace /bin/mv mv
    tcsh $sharedir/TPTP2X/tptp2X_install -default

    patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath ${lib.getLib curl}/lib $sharedir/Scripts/tptp4X

    mkdir -p $out/bin
    ln -s $sharedir/TPTP2X/tptp2X $out/bin
    ln -s $sharedir/Scripts/tptp2T $out/bin
    ln -s $sharedir/Scripts/tptp4X $out/bin
  '';

  meta = with lib; {
    description = "Thousands of problems for theorem provers and tools";
    maintainers = with maintainers; [
      raskin
    ];
    # 6.3 GiB of data. Installation is unpacking and editing a few files.
    # No sense in letting Hydra build it.
    # Also, it is unclear what is covered by "verbatim" - we will edit configs
    hydraPlatforms = [ ];
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    homepage = "https://tptp.org/TPTP/";
  };
}
