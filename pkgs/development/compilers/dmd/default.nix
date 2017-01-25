{ stdenv, fetchurl
, makeWrapper, unzip, which

# Versions 2.070.2 and up require a working dmd compiler to build:
, bootstrapDmd }:

stdenv.mkDerivation rec {
  name = "dmd-${version}";
  version = "2.070.2";

  src = fetchurl {
    url = "http://downloads.dlang.org/releases/2.x/${version}/dmd.${version}.zip";
    sha256 = "1pbhxxf41v816j0aky3q2pcd8a6phy3363l7vr5r5pg8ps3gl701";
  };

  nativeBuildInputs = [ bootstrapDmd makeWrapper unzip which ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
      # Allow to use "clang++", commented in Makefile
      substituteInPlace src/dmd/posix.mak \
          --replace g++ clang++ \
          --replace MACOSX_DEPLOYMENT_TARGET MACOSX_DEPLOYMENT_TARGET_
  '';

  # Buid and install are based on http://wiki.dlang.org/Building_DMD
  buildPhase = ''
      cd src/dmd
      make -f posix.mak INSTALL_DIR=$out
      export DMD=$PWD/dmd
      cd ../druntime
      make -f posix.mak INSTALL_DIR=$out DMD=$DMD
      cd ../phobos
      make -f posix.mak INSTALL_DIR=$out DMD=$DMD
      cd ../..
  '';

  installPhase = ''
      cd src/dmd
      mkdir $out
      mkdir $out/bin
      cp dmd $out/bin

      cd ../druntime
      mkdir $out/include
      mkdir $out/include/d2
      cp -r import/* $out/include/d2

      cd ../phobos
      mkdir $out/lib
      ${let bits = if stdenv.is64bit then "64" else "32";
            osname = if stdenv.isDarwin then "osx" else "linux"; in
      "cp generated/${osname}/release/${bits}/libphobos2.a $out/lib"
      }

      cp -r std $out/include/d2
      cp -r etc $out/include/d2

      wrapProgram $out/bin/dmd \
          --prefix PATH ":" "${stdenv.cc}/bin" \
          --set CC "$""{CC:-$CC""}"

      cd $out/bin
      tee dmd.conf << EOF
      [Environment]
      DFLAGS=-I$out/include/d2 -L-L$out/lib ${stdenv.lib.optionalString (!stdenv.cc.isClang) "-L--no-warn-search-mismatch -L--export-dynamic"}
      EOF
  '';

  meta = with stdenv.lib; {
    description = "D language compiler";
    homepage = http://dlang.org/;
    license = licenses.free; # parts under different licenses
    platforms = platforms.unix;
  };
}
