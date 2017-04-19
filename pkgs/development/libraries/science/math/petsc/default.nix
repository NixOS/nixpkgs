{ stdenv, 
fetchurl, 
mpi,
openblas,
lapack ? null,
blasName ? "",
lapackName ? "",
pkgconfig,
python 
}:

# use openblas for both the blas and lapack backend by default
# provide necessary option if the user want to override to use Intel MKL or other

let
    blas = openblas;
    liblapack = if (lapack == null)  then openblas else lapack;
    blasLibName = if (blasName != "") then blasName else "openblas";
    liblapackLibName = if(lapackName != "") then lapackName else "openblas";
	defaultOptFlags = "-g -O2";
in

stdenv.mkDerivation rec {
  name = "petsc-${version}";
  version = "3.7.3";

  src = fetchurl {
    url = "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-${version}.tar.gz";
    sha256 = "06yd8abwfk3sdzfn0aclyw0fqrggjhdvkxd1w30wd2cbkddpyr9m";
  };


  nativeBuildInputs = [ pkgconfig python ];

  buildInputs = [ blas liblapack mpi];

  preConfigure = ''
        # petsc python configure script want an existing HOME directory
        # we provide him a fake one
        export HOME=$(mktemp -d)
  '';

 
  configureFlags = [ "COPTFLAGS='${defaultOptFlags}'"
                     "CXXOPTFLAGS='${defaultOptFlags}'"
					 "--with-fc=0"  "--with-mpi-dir=${mpi}"
                     "--with-blas-lib=${blas}/lib/lib${blasLibName}.a"
                     "--with-lapack-lib=${liblapack}/lib/lib${liblapackLibName}.a" 
                    ];
   
  doCheck = true;

  crossAttrs = {
  
        ## Fix PETSc cross compilation 
        ##
        ## Unfortunatly, PETSC need three steps configure phase for cross-compilation
        ## 1- configure one on frontend to generate script
        ## 2- run this generated script
        ## 3- configure again on backend
        ##
		## This is not acceptable on Nix nor in any package manager
        ## We fake this behavior by using an already generated script that we reconfigure manually
        ##
        ## Has been tested and validated with a cross-compilation on BlueGene/Q 
		##
        preConfigure = ''
                        export HOME=$(mktemp -d)

                        ## reconfigure script for cross compile
                        substitute ${./reconfigure-arch-linux2-c-debug.py.in} ./reconfigure-arch-linux2-c-debug.py \
                        --replace "@mpi_path@" "${mpi.crossDrv}" \
                        --replace "@liblapack_path@" "${liblapack.crossDrv}" \
                        --replace "@liblapackLibName@" "${liblapackLibName}" \
                        --replace "@blas_path@" "${blas.crossDrv}" \
                        --replace "@blasLibName@" "${blasLibName}" \
                        --replace "@python_interpreter@" "${python}/bin/python"
                        
                        chmod a+x ./reconfigure-arch-linux2-c-debug.py
                       '';

        configureScript = "./reconfigure-arch-linux2-c-debug.py";

        configureFlags = "";

        dontSetConfigureCross = true;
  };


  # -j not supported by petsc
  enableParallelBuilding = false;

  meta = with stdenv.lib; {
    description = "Portable, Extensible Toolkit for Scientific Computation";

    longDescription = ''
    PETSc, pronounced PET-see (the S is silent), is a suite of data structures and routines for the scalable (parallel) solution of scientific applications modeled by partial differential equations. It supports MPI, and GPUs through CUDA or OpenCL, as well as hybrid MPI-GPU parallelism.  
    '';

    homepage = https://www.mcs.anl.gov/petsc/index.html;
    license = licenses.bsd2;
    maintainers = [ maintainers.adev ];
    platforms = platforms.unix; 
  };
}
