{lib, python, buildPythonPackage, isPy27, isPyPy, gfortran, nose, blas}:

args:

let
  inherit (args) version;
in buildPythonPackage (args // rec {

  name = "numpy-${version}";

  disabled = isPyPy;
  buildInputs = args.buildInputs or [ gfortran nose ];
  propagatedBuildInputs = args.propagatedBuildInputs or [ passthru.blas ];

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
    include_dirs = ${passthru.blas}/include
    library_dirs = ${passthru.blas}/lib
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
  } // (args.meta or {});
})
