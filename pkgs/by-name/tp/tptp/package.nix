{
  lib,
  stdenv,
  fetchurl,
  yap,
  tcsh,
  perl,
  patchelf,
}:

stdenv.mkDerivation rec {
  pname = "TPTP";
  version = "7.2.0";

  src = fetchurl {
    urls = [
      "http://tptp.cs.miami.edu/TPTP/Distribution/TPTP-v${version}.tgz"
      "http://tptp.cs.miami.edu/TPTP/Archive/TPTP-v${version}.tgz"
    ];
    sha256 = "0yq8452b6mym4yscy46pshg0z2my8xi74b5bp2qlxd5bjwcrg6rl";
  };

  nativeBuildInputs = [ patchelf ];
  buildInputs = [
    tcsh
    yap
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

    patchelf --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $sharedir/Scripts/tptp4X

    mkdir -p $out/bin
    ln -s $sharedir/TPTP2X/tptp2X $out/bin
    ln -s $sharedir/Scripts/tptp2T $out/bin
    ln -s $sharedir/Scripts/tptp4X $out/bin
  '';

  meta = with lib; {
    description = "Thousands of problems for theorem provers and tools";
    maintainers = with maintainers; [
      raskin
      gebner
    ];
    # 6.3 GiB of data. Installation is unpacking and editing a few files.
    # No sense in letting Hydra build it.
    # Also, it is unclear what is covered by "verbatim" - we will edit configs
    hydraPlatforms = [ ];
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
  };
}
