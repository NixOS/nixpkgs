{ stdenv, fetchurl, gfortran, perl }:

stdenv.mkDerivation rec {
  pname = "spooles";
  version = "2.2";

  src = fetchurl {
    url = "http://www.netlib.org/linalg/spooles/spooles.${version}.tgz";
    sha256 = "1pf5z3vvwd8smbpibyabprdvcmax0grzvx2y0liy98c7x6h5jid8";
  };

  sourceRoot = ".";

  patches = [
    ./spooles.patch
  ];

  buildPhase = ''
    make lib
  '';

  installPhase = ''
    mkdir -p $out/lib $out/include/spooles
    cp libspooles.a libspooles.so.2.2 $out/lib/
    ln -s libspooles.so.2.2 $out/lib/libspooles.so.2
    ln -s libspooles.so.2 $out/lib/libspooles.so
    for h in *.h; do
      if [ $h != 'MPI.h' ]; then
         cp $h $out/include/spooles
         d=`basename $h .h`
         if [ -d $d ]; then
            mkdir $out/include/spooles/$d
            cp $d/*.h $out/include/spooles/$d
         fi
      fi
    done
  '';

  nativeBuildInputs = [ perl ];

  meta = with stdenv.lib; {
    homepage = "http://www.netlib.org/linalg/spooles/";
    description = "Library for solving sparse real and complex linear systems of equations";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.unix;
  };
}
