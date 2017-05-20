{lib, fetchurl, python, buildPythonPackage, isPy27, isPyPy, gfortran, nose, blas}:

buildPythonPackage rec {
  pname = "numpy";
  version = "1.12.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/n/numpy/numpy-${version}.zip";
    sha256 = "a65266a4ad6ec8936a1bc85ce51f8600634a31a258b722c9274a80ff189d9542";
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
  '';

  preBuild = ''
    echo "Creating site.cfg file..."
    cat << EOF > site.cfg
    [openblas]
    include_dirs = ${blas}/include
    library_dirs = ${blas}/lib
    EOF
  '';

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
    homepage = "http://numpy.scipy.org/";
    maintainers = with lib.maintainers; [ fridh ];
  };
}
