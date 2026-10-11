{
  lib,
  stdenv,
  fetchsvn,
  imake,
  bison,
  flex,
  libxt,
  libxpm,
  libxmu,
  libxext,
  libxaw,
  libx11,
  libsm,
  libice,
}:

stdenv.mkDerivation {
  pname = "xspim";
  version = "9.1.22";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/spimsimulator/code/";
    rev = "r739";
    sha256 = "1kazfgrbmi4xq7nrkmnqw1280rhdyc1hmr82flrsa3g1b1rlmj1s";
  };

  nativeBuildInputs = [
    imake
    bison
    flex
  ];
  buildInputs = [
    libice
    libsm
    libx11
    libxaw
    libxext
    libxmu
    libxpm
    libxt
  ];

  preConfigure = ''
    cd xspim
    xmkmf
  '';

  makeFlags = [
    "BIN_DIR=${placeholder "out"}/bin"
    "EXCEPTION_DIR=${placeholder "out"}/share/spim"
    "MAN_DIR=${placeholder "out"}/share/man/man1"
  ];

  doCheck = true;
  preCheck = ''
    pushd ../spim
  '';
  postCheck = ''
    popd
  '';

  preInstall = ''
    mkdir -p $out/share/spim
    install -D ../spim/spim $out/bin/spim
    install -D ../Documentation/spim.man $out/share/man/man1/spim.1
    install -D ../Documentation/xspim.man $out/share/man/man1/xspim.1
  '';

  meta = {
    description = "MIPS32 simulator";
    homepage = "https://spimsimulator.sourceforge.net/";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.linux;
  };
}
