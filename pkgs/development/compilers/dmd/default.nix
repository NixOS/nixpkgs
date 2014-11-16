{ stdenv, fetchurl, unzip, curl }:

stdenv.mkDerivation {
  name = "dmd-2.066.1";

  src = fetchurl {
    url = http://downloads.dlang.org/releases/2014/dmd.2.066.1.zip;
    sha256 = "1qifwgrl6h232zsnvcx3kmb5d0fsy7j9zv17r3b4vln7x5rvzc66";
  };

  buildInputs = [ unzip curl ];

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
      ${let bits = if stdenv.is64bit then "64" else "32"; in
      "cp generated/linux/release/${bits}/libphobos2.a $out/lib"
      }

      cp -r std $out/include/d2
      cp -r etc $out/include/d2

      cd $out/bin
      tee dmd.conf << EOF
      [Environment]
      DFLAGS=-I$out/include/d2 -L-L$out/lib -L--no-warn-search-mismatch -L--export-dynamic
      EOF
  '';

  meta = with stdenv.lib; {
    description = "D language compiler";
    homepage = http://dlang.org/;
    license = licenses.free; # parts under different licenses
    platforms = platforms.unix;
  };
}

