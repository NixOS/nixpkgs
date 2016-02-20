{lib, python, buildPythonPackage, isPyPy, gfortran, nose, blas}:

args:

let
  inherit (args) version;
in buildPythonPackage (args // rec {

  name = "numpy-${version}";

  disabled = isPyPy;
  buildInputs = args.buildInputs or [ gfortran nose ];
  propagatedBuildInputs = args.propagatedBuildInputs or [ passthru.blas ];

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

  passthru = {
    blas = blas;
  };

  # The large file support test is disabled because it takes forever
  # and can cause the machine to run out of disk space when run.
  prePatch = ''
    sed -i 's/test_large_file_support/donttest/' numpy/lib/tests/test_format.py
  '';

  meta = {
    description = "Scientific tools for Python";
    homepage = "http://numpy.scipy.org/";
    maintainers = with lib.maintainers; [ fridh ];
  } // (args.meta or {});
})
