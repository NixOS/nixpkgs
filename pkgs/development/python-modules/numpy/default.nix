{lib, fetchPypi, python, buildPythonPackage, isPy27, isPyPy, gfortran, nose, blas, hostPlatform }:

buildPythonPackage rec {
  pname = "numpy";
  version = "1.14.3";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "9016692c7d390f9d378fc88b7a799dc9caa7eb938163dda5276d3f3d6f75debf";
  };

  disabled = isPyPy;
  buildInputs = [ gfortran nose blas ];

  patches = lib.optionals (python.hasDistutilsCxxPatch or false) [
    # We patch cpython/distutils to fix https://bugs.python.org/issue1222585
    # Patching of numpy.distutils is needed to prevent it from undoing the
    # patch to distutils.
    ./numpy-distutils-C++.patch
  ];

  postPatch = lib.optionalString hostPlatform.isMusl ''
    # Use fenv.h
    sed -i \
      numpy/core/src/npymath/ieee754.c.src \
      numpy/core/include/numpy/ufuncobject.h \
      -e 's/__GLIBC__/__linux__/'
    # Don't use various complex trig functions
    substituteInPlace numpy/core/src/private/npy_config.h \
      --replace '#if defined(__GLIBC__)' "#if 1" \
      --replace '#if !__GLIBC_PREREQ(2, 18)' "#if 1"
  '';

  preConfigure = ''
    sed -i 's/-faltivec//' numpy/distutils/system_info.py
    export NPY_NUM_BUILD_JOBS=$NIX_BUILD_CORES
  '';

  preBuild = ''
    echo "Creating site.cfg file..."
    cat << EOF > site.cfg
    [openblas]
    include_dirs = ${blas}/include
    library_dirs = ${blas}/lib
    EOF
  '';

  enableParallelBuilding = true;

  checkPhase = ''
    runHook preCheck
    pushd dist
    ${python.interpreter} -c 'import numpy; numpy.test("fast", verbose=10)'
    popd
    runHook postCheck
  '';

  postInstall = ''
    ln -s $out/bin/f2py* $out/bin/f2py
  '';

  passthru = {
    blas = blas;
  };

  # Disable two tests
  # - test_f2py: f2py isn't yet on path.
  # - test_large_file_support: takes a long time and can cause the machine to run out of disk space
  NOSE_EXCLUDE="test_f2py,test_large_file_support";

  meta = {
    description = "Scientific tools for Python";
    homepage = http://numpy.scipy.org/;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
