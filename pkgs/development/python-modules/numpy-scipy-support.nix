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
    pushd dist
    ${python.interpreter} -c 'import ${pkgName}; ${pkgName}.test("fast", verbose=10)'
    popd
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
