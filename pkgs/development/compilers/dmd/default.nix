{ stdenv, fetchurl, gcc, unzip, curl }:

stdenv.mkDerivation {
  name = "dmd-2.064.2";

  src = fetchurl {
    url = http://downloads.dlang.org/releases/2013/dmd.2.064.2.zip;
    sha256 = "1i0jdybigffwyb7c43j0c4aayxx3b93zzqrjxyw6zgp06yhi06pm";
  };

  buildInputs = [ gcc unzip curl ];

  configurePhase = "";
  patchPhase = ''
      cp src/VERSION src/dmd/
      cp license.txt src/phobos/LICENSE_1_0.txt
  '';
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
      tee dmd.conf.default << EOF
          [Environment]
          DFLAGS=-I$out/import -L-L$out/lib
      EOF

      make -f posix.mak INSTALL_DIR=$out install
      export DMD=$PWD/dmd
      cd ../druntime 
      make -f posix.mak INSTALL_DIR=$out install
      cd ../phobos
      make -f posix.mak INSTALL_DIR=$out install
      cd ../..
  '';

  meta = {
    description = "D language compiler";
    homepage = http://dlang.org/;
    license = "open source, see included files";
    maintainers = with stdenv.lib.maintainers; [ vlstill ];
    platforms = stdenv.lib.platforms.unix;
  };
}
