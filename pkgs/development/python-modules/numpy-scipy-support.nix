{
  # Python package expression
  python,
  # Name of package (e.g. numpy or scipy)
  pkgName,
  # OpenBLAS math library
  openblas
}:

{
  # Re-export openblas here so that it can be sure that the same one will be used
  # in the propagatedBuildInputs.
  inherit openblas;

  # First "install" the package, then import what was installed, and call the
  # .test() function, which will run the test suite.
  checkPhase = ''
    runHook preCheck

    _python=${python}/bin/${python.executable}

    # We will "install" into a temp directory, so that we can run the
    # tests (see below).
    install_dir="$TMPDIR/test_install"
    install_lib="$install_dir/lib/${python.libPrefix}/site-packages"
    mkdir -p $install_dir
    $_python setup.py install \
      --install-lib=$install_lib \
      --old-and-unmanageable \
      --prefix=$install_dir > /dev/null

    # Create a directory in which to run tests (you get an error if you try to
    # import the package when you're in the current directory).
    mkdir $TMPDIR/run_tests
    pushd $TMPDIR/run_tests > /dev/null
    # Temporarily add the directory we installed in to the python path
    # (not permanently, or this pythonpath will wind up getting exported),
    # and run the test suite.
    PYTHONPATH="$install_lib:$PYTHONPATH" $_python -c \
      'import ${pkgName}; ${pkgName}.test("fast", verbose=10)'
    popd > /dev/null

    runHook postCheck
  '';

  # Creates a site.cfg telling the setup script where to find depended-on
  # math libraries.
  preBuild = ''
    echo "Creating site.cfg file..."
    cat << EOF > site.cfg
    [openblas]
    include_dirs = ${openblas}/include
    library_dirs = ${openblas}/lib
    EOF
  '';
}
