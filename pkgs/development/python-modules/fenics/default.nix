{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  blas,
  boost186,
  buildPythonPackage,
  cmake,
  doxygen,
  eigen,
  hdf5,
  isPy27,
  lapack,
  mpi,
  mpi4py,
  numpy,
  pkg-config,
  pkgconfig,
  ply,
  pybind11,
  pytest,
  python,
  scotch,
  setuptools,
  six,
  sphinx,
  suitesparse,
  swig,
  sympy,
  zlib,
  nixosTests,
}:

let
  version = "2019.1.0";

  dijitso = buildPythonPackage {
    pname = "dijitso";
    inherit version;
    format = "setuptools";
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/dijitso/downloads/dijitso-${version}.tar.gz";
      sha256 = "1ncgbr0bn5cvv16f13g722a0ipw6p9y6p4iasxjziwsp8kn5x97a";
    };
    propagatedBuildInputs = [
      numpy
      six
    ];
    nativeCheckInputs = [ pytest ];
    preCheck = ''
      export HOME=$PWD
    '';
    checkPhase = ''
      runHook preCheck
      py.test test/
      runHook postCheck
    '';
    meta = {
      description = "Distributed just-in-time shared library building";
      homepage = "https://fenicsproject.org/";
      platforms = lib.platforms.all;
      license = lib.licenses.lgpl3;
    };
  };

  fiat = buildPythonPackage {
    pname = "fiat";
    inherit version;
    format = "setuptools";
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/fiat/downloads/fiat-${version}.tar.gz";
      sha256 = "1sbi0fbr7w9g9ajr565g3njxrc3qydqjy3334vmz5xg0rd3106il";
    };
    propagatedBuildInputs = [
      numpy
      six
      sympy
    ];
    nativeCheckInputs = [ pytest ];

    preCheck = ''
      # Workaround pytest 4.6.3 issue.
      # See: https://bitbucket.org/fenics-project/fiat/pull-requests/59
      rm test/unit/test_quadrature.py
      rm test/unit/test_reference_element.py
      rm test/unit/test_fiat.py

      # Fix `np.float` deprecation in Numpy 1.20
      grep -lr 'np.float(' test/ | while read -r fn; do
        substituteInPlace "$fn" \
          --replace "np.float(" "np.float64("
      done
    '';
    checkPhase = ''
      runHook preCheck
      py.test test/unit/
      runHook postCheck
    '';
    meta = {
      description = "Automatic generation of finite element basis functions";
      homepage = "https://fenicsproject.org/";
      platforms = lib.platforms.all;
      license = lib.licenses.lgpl3;
    };
  };

  ufl = buildPythonPackage {
    pname = "ufl";
    inherit version;
    format = "setuptools";
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/ufl/downloads/ufl-${version}.tar.gz";
      sha256 = "04daxwg4y9c51sdgvwgmlc82nn0fjw7i2vzs15ckdc7dlazmcfi1";
    };
    propagatedBuildInputs = [
      numpy
      six
    ];
    nativeCheckInputs = [ pytest ];
    checkPhase = ''
      runHook preCheck
      py.test test/
      runHook postCheck
    '';
    meta = {
      description = "Domain-specific language for finite element variational forms";
      homepage = "https://fenicsproject.org/";
      platforms = lib.platforms.all;
      license = lib.licenses.lgpl3;
    };
  };

  ffc = buildPythonPackage {
    pname = "ffc";
    inherit version;
    format = "setuptools";
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/ffc/downloads/ffc-${version}.tar.gz";
      sha256 = "1zdg6pziss4va74pd7jjl8sc3ya2gmhpypccmyd8p7c66ji23y2g";
    };
    patches = [
      (fetchpatch {
        name = "fenics-ffc-numpy2-compat.patch";
        url = "https://bitbucket.org/fenics-project/ffc/commits/245d15115b35b5ac091251fe6c84cc6474704b3c/raw";
        hash = "sha256-TcLQZ44C+uR2ryxtCBjR/5Tjn7B0S4MqoYi0nlP8JwI=";
      })
    ];
    nativeBuildInputs = [ pybind11 ];
    propagatedBuildInputs = [
      dijitso
      fiat
      numpy
      six
      sympy
      ufl
      setuptools
    ];
    nativeCheckInputs = [ pytest ];
    preCheck = ''
      export HOME=$PWD
      rm test/unit/ufc/finite_element/test_evaluate.py
    '';
    checkPhase = ''
      runHook preCheck
      py.test test/unit/
      runHook postCheck
    '';
    meta = {
      description = "Compiler for finite element variational forms";
      homepage = "https://fenicsproject.org/";
      platforms = lib.platforms.all;
      license = lib.licenses.lgpl3;
    };
  };
  dolfin = stdenv.mkDerivation {
    pname = "dolfin";
    inherit version;
    src = fetchurl {
      url = "https://bitbucket.org/fenics-project/dolfin/downloads/dolfin-${version}.tar.gz";
      sha256 = "0kbyi4x5f6j4zpasch0swh0ch81w2h92rqm1nfp3ydi4a93vky33";
    };
    patches = [
      (fetchpatch {
        name = "fix-double-prefix.patch";
        url = "https://bitbucket.org/josef_kemetmueller/dolfin/commits/328e94acd426ebaf2243c072b806be3379fd4340/raw";
        sha256 = "1zj7k3y7vsx0hz3gwwlxhq6gdqamqpcw90d4ishwx5ps5ckcsb9r";
      })
      (fetchpatch {
        url = "https://bitbucket.org/fenics-project/dolfin/issues/attachments/1116/fenics-project/dolfin/1602778118.04/1116/0001-Use-__BYTE_ORDER__-instead-of-removed-Boost-endian.h.patch";
        hash = "sha256-wPaDmPU+jaD3ce3nNEbvM5p8e3zBdLozamLTJ/0ai2c=";
      })
      (fetchpatch {
        name = "fenics-boost-filesystem-1.85-compat.patch.";
        url = "https://bitbucket.org/sblauth/dolfin/commits/16fa03887b3e9ec417c484ddf92db104cb9a93f9/raw";
        hash = "sha256-ZMKfzeWlPre88cKzrj04Tj+nQWS4ixat0bBvyt3TJmk=";
      })
    ];
    # https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=dolfin&id=a965ad934f7b3d49a5e77fa6fb5e3c710ec2163e
    postPatch = ''
      sed -i '20 a #include <algorithm>' dolfin/geometry/IntersectionConstruction.cpp
      sed -i '26 a #include <algorithm>' dolfin/mesh/MeshFunction.h
      sed -i '25 a #include <cstdint>' dolfin/mesh/MeshConnectivity.h
    '';
    propagatedBuildInputs = [
      dijitso
      fiat
      numpy
      six
      ufl
    ];
    nativeBuildInputs = [
      cmake
      doxygen
      pkg-config
    ];
    buildInputs = [
      boost186
      dijitso
      eigen
      ffc
      fiat
      hdf5
      mpi
      numpy
      blas
      lapack
      ply
      python
      scotch
      six
      sphinx
      suitesparse
      swig
      sympy
      ufl
      zlib
    ];
    cmakeFlags = [
      "-DDOLFIN_CXX_FLAGS=-std=c++11"
      "-DDOLFIN_AUTO_DETECT_MPI=ON"
      "-DDOLFIN_ENABLE_CHOLMOD=ON"
      "-DDOLFIN_ENABLE_DOCS=ON"
      "-DDOLFIN_ENABLE_HDF5=ON"
      "-DDOLFIN_ENABLE_MPI=ON"
      "-DDOLFIN_ENABLE_SCOTCH=ON"
      "-DDOLFIN_ENABLE_UMFPACK=ON"
      "-DDOLFIN_ENABLE_ZLIB=ON"
      "-DDOLFIN_SKIP_BUILD_TESTS=ON" # Otherwise SCOTCH is not found
      # TODO: Enable the following features
      "-DDOLFIN_ENABLE_PARMETIS=OFF"
      "-DDOLFIN_ENABLE_PETSC=OFF"
      "-DDOLFIN_ENABLE_SLEPC=OFF"
      "-DDOLFIN_ENABLE_TRILINOS=OFF"
    ];
    installCheckPhase = ''
      source $out/share/dolfin/dolfin.conf
      make runtests
    '';
    meta = {
      description = "FEniCS Problem Solving Environment in Python and C++";
      homepage = "https://fenicsproject.org/";
      license = lib.licenses.lgpl3;
    };
  };
  python-dolfin = buildPythonPackage rec {
    pname = "dolfin";
    inherit version;
    format = "setuptools";
    disabled = isPy27;
    src = dolfin.src;
    sourceRoot = "${pname}-${version}/python";
    nativeBuildInputs = [
      pybind11
      cmake
    ];
    dontUseCmakeConfigure = true;
    preConfigure = ''
      export CMAKE_PREFIX_PATH=${pybind11}/share/cmake/pybind11:$CMAKE_PREFIX_PATH
      substituteInPlace setup.py --replace "pybind11==2.2.4" "pybind11"
      substituteInPlace dolfin/jit/jit.py \
        --replace 'pkgconfig.exists("dolfin")' 'pkgconfig.exists("${dolfin}/lib/pkgconfig/dolfin.pc")' \
        --replace 'pkgconfig.parse("dolfin")' 'pkgconfig.parse("${dolfin}/lib/pkgconfig/dolfin.pc")'
    '';
    buildInputs = [
      dolfin
      boost186
    ];

    propagatedBuildInputs = [
      dijitso
      ffc
      mpi4py
      numpy
      ufl
      pkgconfig
      pybind11
    ];
    doCheck = false; # Tries to orte_ess_init and call ssh to localhost
    passthru.tests = {
      inherit (nixosTests) fenics;
    };
    meta = {
      description = "Python bindings for the DOLFIN FEM compiler";
      homepage = "https://fenicsproject.org/";
      platforms = lib.platforms.all;
      license = lib.licenses.lgpl3;
    };
  };
in
python-dolfin
