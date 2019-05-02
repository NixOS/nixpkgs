{ stdenv
, fetchurl
, boost
, cmake
, doxygen
, eigen
, numpy
, pkgconfig
, pytest
, pythonPackages
, six
, sympy
, gtest ? null
, hdf5 ? null
, mpi ? null
, ply ? null
, python ? null
, sphinx ? null
, suitesparse ? null
, swig ? null
, vtk ? null
, zlib ? null
, docs ? false
, pythonBindings ? false
, doCheck ? true }:

assert pythonBindings -> python != null && ply != null && swig != null;

let
  version = "2017.1.0";

  dijitso = pythonPackages.buildPythonPackage {
    name = "dijitso-${version}";
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/dijitso/downloads/dijitso-${version}.tar.gz";
      sha256 = "0mw6mynjmg6yl3l2k33yra2x84s4r6mh44ylhk9znjfk74jra8zg";
    };
    buildInputs = [ numpy pytest six ];
    checkPhase = ''
      export HOME=$PWD
      py.test test/
    '';
    meta = {
      description = "Distributed just-in-time shared library building";
      homepage = https://fenicsproject.org/;
      platforms = stdenv.lib.platforms.all;
      license = stdenv.lib.licenses.lgpl3;
    };
  };

  fiat = pythonPackages.buildPythonPackage {
    name = "fiat-${version}";
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/fiat/downloads/fiat-${version}.tar.gz";
      sha256 = "156ybz70n4n7p88q4pfkvbmg1xr2ll80inzr423mki0nml0q8a6l";
    };
    buildInputs = [ numpy pytest six sympy ];
    checkPhase = ''
      py.test test/unit/
    '';
    meta = {
      description = "Automatic generation of finite element basis functions";
      homepage = https://fenicsproject.org/;
      platforms = stdenv.lib.platforms.all;
      license = stdenv.lib.licenses.lgpl3;
    };
  };

  ufl = pythonPackages.buildPythonPackage {
    name = "ufl-${version}";
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/ufl/downloads/ufl-${version}.tar.gz";
      sha256 = "13ysimmwad429fjjs07j1fw1gq196p021j7mv66hwrljyh8gm1xg";
    };
    buildInputs = [ numpy pytest six ];
    checkPhase = ''
      py.test test/
    '';
    meta = {
      description = "A domain-specific language for finite element variational forms";
      homepage = http://fenicsproject.org/;
      platforms = stdenv.lib.platforms.all;
      license = stdenv.lib.licenses.lgpl3;
    };
  };

  ffc = pythonPackages.buildPythonPackage {
    name = "ffc-${version}";
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/ffc/downloads/ffc-${version}.tar.gz";
      sha256 = "1cw7zsrjms11xrfg7x9wjd90x3w4v5s1wdwa18xqlycqz7cc8wr0";
    };
    buildInputs = [ dijitso fiat numpy pytest six sympy ufl ];
    checkPhase = ''
      export HOME=$PWD
      py.test test/unit/
    '';
    meta = {
      description = "A compiler for finite element variational forms";
      homepage = http://fenicsproject.org/;
      platforms = stdenv.lib.platforms.all;
      license = stdenv.lib.licenses.lgpl3;
    };
  };

  instant = pythonPackages.buildPythonPackage {
    name = "instant-${version}";
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/instant/downloads/instant-${version}.tar.gz";
      sha256 = "1rsyh6n04w0na2zirfdcdjip8k8ikb8fc2x94fq8ylc3lpcnpx9q";
    };
    buildInputs = [ numpy six ];
    meta = {
      description = "Instant inlining of C and C++ code in Python";
      homepage = http://fenicsproject.org/;
      platforms = stdenv.lib.platforms.all;
      license = stdenv.lib.licenses.lgpl3;
    };
  };

in
stdenv.mkDerivation {
  name = "dolfin-${version}";
  src = fetchurl {
    url = "https://bitbucket.org/fenics-project/dolfin/downloads/dolfin-${version}.tar.gz";
    sha256 = "14hfb5q6rz79zmy742s2fiqkb9j2cgh5bsg99v76apcr84nklyds";
  };
  propagatedBuildInputs = [ dijitso fiat numpy six ufl ];
  buildInputs = [
    boost cmake dijitso doxygen eigen ffc fiat gtest hdf5 instant mpi
    numpy pkgconfig six sphinx suitesparse sympy ufl vtk zlib
    ] ++ stdenv.lib.optionals pythonBindings [ ply python numpy swig ];
  patches = [ ./unicode.patch ];
  cmakeFlags = "-DDOLFIN_CXX_FLAGS=-std=c++11"
    + " -DDOLFIN_AUTO_DETECT_MPI=OFF"
    + " -DDOLFIN_ENABLE_CHOLMOD=" + (if suitesparse != null then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_DOCS=" + (if docs then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_GTEST=" + (if gtest != null then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_HDF5=" + (if hdf5 != null then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_MPI=" + (if mpi != null then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_PARMETIS=OFF"
    + " -DDOLFIN_ENABLE_PETSC4PY=OFF"
    + " -DDOLFIN_ENABLE_PETSC=OFF"
    + " -DDOLFIN_ENABLE_PYTHON=" + (if pythonBindings then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_SCOTCH=OFF"
    + " -DDOLFIN_ENABLE_SLEPC4PY=OFF"
    + " -DDOLFIN_ENABLE_SLEPC=OFF"
    + " -DDOLFIN_ENABLE_SPHINX=" + (if sphinx != null then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_TESTING=" + (if doCheck then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_TRILINOS=OFF"
    + " -DDOLFIN_ENABLE_UMFPACK=" + (if suitesparse != null then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_VTK=" + (if vtk != null then "ON" else "OFF")
    + " -DDOLFIN_ENABLE_ZLIB=" + (if zlib != null then "ON" else "OFF");
  checkPhase = ''
    make runtests
  '';
  postInstall = "source $out/share/dolfin/dolfin.conf";
  meta = {
    description = "The FEniCS Problem Solving Environment in Python and C++";
    homepage = http://fenicsproject.org/;
    platforms = stdenv.lib.platforms.darwin;
    license = stdenv.lib.licenses.lgpl3;
  };
}
