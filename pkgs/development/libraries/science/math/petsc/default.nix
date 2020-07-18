{ stdenv , darwin , fetchurl , blas , gfortran , lapack , python }:

stdenv.mkDerivation rec {
  pname = "petsc";
  version = "3.13.2";

  src = fetchurl {
    url = "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-${version}.tar.gz";
    sha256 = "0yf5lm8dqpbz1yq9nvd5g2iy2w0rgjp9vcj44ba63rwig37j3clp";
  };

  nativeBuildInputs = [ blas gfortran gfortran.cc.lib lapack python ];

  # Upstream does some hot she-py-bang stuff, this change streamlines that
  # process. The original script in upstream is both a shell script and a
  # python script, where the shellscript just finds a suitable python
  # interpreter to execute the python script. See
  # https://github.com/NixOS/nixpkgs/pull/89299#discussion_r450203444 
  # for more details.
  prePatch = ''
    substituteInPlace configure \
      --replace /bin/sh /usr/bin/python
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace config/install.py \
      --replace /usr/bin/install_name_tool ${darwin.cctools}/bin/install_name_tool
  '';

  preConfigure = ''
    export FC="${gfortran}/bin/gfortran" F77="${gfortran}/bin/gfortran"
    patchShebangs .
    configureFlagsArray=(
      $configureFlagsArray
      "--CC=$CC"
      "--with-cxx=$CXX"
      "--with-fc=$FC"
      "--with-mpi=0"
      "--with-blas-lib=[${blas}/lib/libblas.so,${gfortran.cc.lib}/lib/libgfortran.a]"
      "--with-lapack-lib=[${lapack}/lib/liblapack.so,${gfortran.cc.lib}/lib/libgfortran.a]"
    )
  '';

  meta = with stdenv.lib; {
    description = ''
      Library of linear algebra algorithms for solving partial differential
      equations
    '';
    homepage = "https://www.mcs.anl.gov/petsc/index.html";
    license = licenses.bsd2;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.all;
  };
}
