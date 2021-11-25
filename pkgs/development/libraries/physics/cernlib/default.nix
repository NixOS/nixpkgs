{ lib, stdenv, fetchurl, gfortran, gnumake, imake, makedepend, motif, xorg }:

stdenv.mkDerivation rec {
  version = "2006";
  pname = "cernlib";

  src = fetchurl {
    urls = [
      "https://ftp.riken.jp/cernlib/download/${version}_source/tar/${version}_src.tar.gz"
      "https://cernlib.web.cern.ch/cernlib/download/${version}_source/tar/${version}_src.tar.gz"
    ];
    sha256 = "0awla1rl96z82br7slcmg8ks1d2a7slk6dj79ywb871j2ksi3fky";
  };

  buildInputs = with xorg; [ gfortran motif libX11 libXft libXt ];
  nativeBuildInputs = [ gnumake imake makedepend ];
  sourceRoot = ".";

  patches = [ ./patch.patch ./0001-Use-strerror-rather-than-sys_errlist-to-fix-compilat.patch ];

  postPatch = ''
    substituteInPlace 2006/src/config/site.def \
      --replace "# define MakeCmd gmake" "# define MakeCmd make"
    substituteInPlace 2006/src/config/lnxLib.rules \
      --replace "# lib" "// lib"
    # binutils 2.37 fix
    substituteInPlace 2006/src/config/Imake.tmpl --replace "clq" "cq"
  '';

  configurePhase = ''
    export CERN=`pwd`
    export CERN_LEVEL=${version}
    export CERN_ROOT=$CERN/$CERN_LEVEL
    export CVSCOSRC=`pwd`/$CERN_LEVEL/src
    export PATH=$PATH:$CERN_ROOT/bin
  '';

  FFLAGS = lib.optionals (lib.versionAtLeast gfortran.version "10.0.0") [
    # Fix https://github.com/vmc-project/geant3/issues/17
    "-fallow-invalid-boz"

    # Fix for gfortran 10
    "-fallow-argument-mismatch"
  ];

  makeFlags = [
    "FORTRANOPTIONS=$(FFLAGS)"
  ];

  buildPhase = ''
    cd $CERN_ROOT
    mkdir -p build bin lib

    cd $CERN_ROOT/build
    $CVSCOSRC/config/imake_boot
    make -j $NIX_BUILD_CORES $makeFlags bin/kuipc
    make -j $NIX_BUILD_CORES $makeFlags scripts/Makefile
    pushd scripts
    make -j $NIX_BUILD_CORES $makeFlags install.bin
    popd
    make -j $NIX_BUILD_CORES $makeFlags
  '';

  installPhase = ''
    mkdir "$out"
    cp -r "$CERN_ROOT/bin" "$out"
    cp -r "$CERN_ROOT/lib" "$out"
    mkdir "$out/$CERN_LEVEL"
    ln -s "$out/bin" "$out/$CERN_LEVEL/bin"
    ln -s "$out/lib" "$out/$CERN_LEVEL/lib"
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "http://cernlib.web.cern.ch";
    description = "Legacy collection of libraries and modules for data analysis in high energy physics";
    broken = stdenv.isDarwin;
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    maintainers = with lib.maintainers; [ veprbl ];
    license = lib.licenses.gpl2;
  };
}
