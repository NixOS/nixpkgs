{lib, fetchurl, python, buildPythonPackage, isPy27, isPyPy, gfortran, nose, blas}:

buildPythonPackage rec {
  pname = "numpy";
  version = "1.13.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/n/numpy/numpy-${version}.zip";
    sha256 = "c9b0283776085cb2804efff73e9955ca279ba4edafd58d3ead70b61d209c4fbb";
  };

  disabled = isPyPy;
  buildInputs = [ gfortran nose blas ];

  patches = lib.optionals (python.hasDistutilsCxxPatch or false) [
    # See cpython 2.7 patches.
    # numpy.distutils is used by cython during it's check phase
    ./numpy-distutils-C++.patch
  ];

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
